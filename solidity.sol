// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ChildrenSavings {
// owner Dr. S .O. Omoruyi
address owner;


event logChildFundingRecieved(address adr, uint amount, uint contractBalance);


constructor(){
    owner = msg.sender;
}


// Define a child 

 struct child {
     address payable walletAddress;
     string firstName;
     string lastName;
     uint releaseTime;
     uint amount;
     bool canWithdraw;
 }
child[] public  children;

modifier onlyOwner(){
    require(msg.sender == owner, "Only Contract Owner can add a child");
    _;
}


// Add Child to contract
 
function addChild(address payable  walletAddress, string memory firstName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public onlyOwner{
        children.push(child(
        walletAddress,
        firstName, 
        lastName, 
        releaseTime, 
        amount,
        canWithdraw));
     } 



// Deposit funds to contract specifically into a child's wallet  

function deposit (address walletAddress) payable public {
    addToChildsBalance(walletAddress);
}


function addToChildsBalance(address walletAddress) private {
    for(uint i = 0; i < children.length; i++){
        if (children[i].walletAddress == walletAddress){
            children[i].amount += msg.value;
          emit logChildFundingRecieved(walletAddress, msg.value, balanceOf());
        }
    }
}



// To get Balance of childs account

function balanceOf() public view returns(uint){
    return address(this).balance;
}


function getIndex(address walletAddress) view private returns(uint){
    for (uint i = 0; i < children.length; i++){
        if(children[i].walletAddress == walletAddress){
            return i;
        }
    }
    return 888;
}

// Child checks if able to withdraw

function availableToWithdraw(address walletAddress) public returns(bool){
 uint i = getIndex(walletAddress);
 require(block.timestamp > children[i].releaseTime,"! You Can't Access Money Yet");
 if(block.timestamp > children[i].releaseTime){
    children[i].canWithdraw = true;
    return true;
 }  
  else {
      return false;
  }
}


// Withdraw Funds

function withdraw(address payable walletAddress) payable public {
 uint i = getIndex(walletAddress);
 require(msg.sender == children[i].walletAddress, "You Must Be The Specific Child to Withdraw!");
 require(children[i].canWithdraw == true, "! You Can't Access Money Yet");
 children[i].walletAddress.transfer(children[i].amount);
}

}