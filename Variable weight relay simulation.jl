
#In this version, liquidity tokens ($_ETH_lt, $_token_lt) are issued directly prop. to ETH and tokens staked

e = 2.7182818284590 #Euler's constant, for log. operations

ETH_balance = 1000 #initial ETH balance
ETH_weight = 0.9090909090909091 #normalized weight of ETH
token_balance = 17100 #initial token balance
token_weight = 0.09090909090909091 #normalized weight of tokens

V = ETH_balance^ETH_weight * token_balance^token_weight #formula from Balancer whitepaper
SP = (token_balance/token_weight) / (ETH_balance/ETH_weight) #spot price

ETH_lt = ETH_balance #initial ETH liquidity tokens
token_lt = token_balance #initial token liquidity tokens

println("V: ", V)
println("SP: ", SP)
println("ETH_lt: ", ETH_lt)
println("token_lt: ", token_lt)

#add stake with CUSTOM weighting
#V should change, price (SP) should remain the same
#mint new ETH_lt, token_LT

custom_weight = (0.7,0.3) #custom weights (ETH,token)
ETH_add = 50 #how much ETH to stake
token_add = (ETH_add*SP) * ((1-custom_weight[1])/custom_weight[1]) #how many tokens to stake, acc. to weights
ETH_balance += ETH_add #add stake to ETH pool
token_balance += token_add #add token stake to token pool

ETH_weight = 1 - (1/((ETH_balance * SP / token_balance )+1)) #update ETH weight (weighted mean)
token_weight = 1/((ETH_balance * SP / token_balance )+1) #update token weight (weighted mean)

V = ETH_balance^ETH_weight * token_balance^token_weight #update invariant (it should change)

ETH_lt += ETH_add #update ETH liq. token pool
token_lt += token_add #update token liq. token pool

my_ETH_lt = ETH_add #how many liq. tokens go to staker
my_token_lt = token_add #how many liq. tokens go to staker

println("ETH_weight: ", ETH_weight) #updated weight
println("token_weight: ", token_weight) #updated weight
println()
println("ETH liq. tokens: ", my_ETH_lt) #staker's ETH liq. tokens
println("token liq. tokens: ", my_token_lt) #staker's token liq. tokens
println()

#check spot price (should be same)
SP = (token_balance/token_weight) / (ETH_balance/ETH_weight) 
println("Spot price: ", SP)

#add another stake with CUSTOM weighting (same as above, just a new stake)
#V should change, price should remain the same
#mint new ETH_lt, token_LT

custom_weight = (0.4, 0.6) #custom weights (ETH,token)
ETH_add = 120 #how much ETH to stake
token_add = (ETH_add*SP) * ((1-custom_weight[1])/custom_weight[1])
ETH_balance += ETH_add #update ETH liquidity pool
token_balance += token_add #update token liquidity pool

ETH_weight = 1 - (1/((ETH_balance * SP / token_balance )+1)) #update ETH weight
token_weight = 1/((ETH_balance * SP / token_balance )+1) #update token weight

V = ETH_balance^ETH_weight * token_balance^token_weight #update invariant

ETH_lt += ETH_add
token_lt += token_add

your_ETH_lt = ETH_add #new staker's ETH liq. tokens
your_token_lt = token_add #staker's token liq. tokens

println("ETH_weight: ", ETH_weight)
println("token_weight: ", token_weight)
println()
println("ETH liq. tokens: ", your_ETH_lt)
println("token liq. tokens: ", your_token_lt)
println()

#check spot price (should not change from staking)
SP = (token_balance/token_weight) / (ETH_balance/ETH_weight) 
println("Spot price: ", SP)

#Verify that original staker still has originally-weighted assets and balances (see above for values)
show(my_ETH_lt/ETH_lt * ETH_balance == 50)
println()
show(my_token_lt/token_lt * token_balance == 3664.285714285715)
println()
show(round((my_token_lt/token_lt * token_balance) / ((my_ETH_lt/ETH_lt * ETH_balance)*SP), digits = 5) ==
    round(0.3/0.7, digits = 5))

#add another stake with CUSTOM weighting
#V should change, price should remain the same
#mint new ETH_lt, token_LT

custom_weight = (0.2, 0.8) #custom weights (ETH,token)
ETH_add = 30 #how much ETH to stake
token_add = (ETH_add*SP) * ((1-custom_weight[1])/custom_weight[1])
ETH_balance += ETH_add #update ETH liquidity pool
token_balance += token_add #update token liquidity pool

ETH_weight = 1 - (1/((ETH_balance * SP / token_balance )+1)) #update ETH weight
token_weight = 1/((ETH_balance * SP / token_balance )+1) #update token weight

V = ETH_balance^ETH_weight * token_balance^token_weight #update invariant

ETH_lt += ETH_add
token_lt += token_add

her_ETH_lt = ETH_add #new staker's ETH liq. tokens
her_token_lt = token_add #new staker's token liq. tokens

println("ETH_weight: ", ETH_weight)
println("token_weight: ", token_weight)
println()
println("ETH liq. tokens: ", your_ETH_lt)
println("token liq. tokens: ", your_token_lt)
println()

#check spot price (should not change from staking)
SP = (token_balance/token_weight) / (ETH_balance/ETH_weight) 
println("Spot price: ", SP)

#Verify that second staker still has originally-weighted assets and balances (see above for values)
show(your_ETH_lt/ETH_lt * ETH_balance == 120)
println()
show(your_token_lt/token_lt * token_balance == 30779.999999999996)
println()
show(round(((your_ETH_lt/ETH_lt * ETH_balance)*SP) / (your_token_lt/token_lt * token_balance), digits = 5) ==
    round(0.4/0.6, digits = 5))

#Does it work with swaps?

#sell tokens (buy ETH)

V = ETH_balance^ETH_weight * token_balance^token_weight #update invariant (should not change from swap)

sale = 5000 #how many tokens to send to contract (swap for ETH)
token_balance += sale #add sale tokens to contract
old_ETH_balance = ETH_balance #store for calculation below
ETH_balance = e^((log(V / (token_balance^token_weight)))/ETH_weight) #update ETH balance according to sale
ETH_received = old_ETH_balance - ETH_balance #ETH received for swapped tokens
println("Tokens sold: ", sale)
println("ETH received: ", ETH_received)
println()

V = ETH_balance^ETH_weight * token_balance^token_weight #update invariant (should not chance)
SP = (token_balance/token_weight) / (ETH_balance/ETH_weight) 
println("V: ", V)
println("SP: ", SP)

#Verify that original staker still has originally-weighted assets and balances (see above for values)
#balances will have changed b/c of swap, but weithed ratio should remain constant
show(round((my_token_lt/token_lt * token_balance) / ((my_ETH_lt/ETH_lt * ETH_balance)*SP), digits = 5) ==
    round(0.3/0.7, digits = 5))

println()

#Verify that second staker still has originally-weighted assets and balances (see above for values)
#balances will have changed b/c of swap, but weithed ratio should remain constant
show(round(((your_ETH_lt/ETH_lt * ETH_balance)*SP) / (your_token_lt/token_lt * token_balance), digits = 5) ==
    round(0.4/0.6, digits = 5))

println()

#Verify that third staker still has originally-weighted assets and balances (see above for values)
#balances will have changed b/c of swap, but weithed ratio should remain constant
show(round(((her_ETH_lt/ETH_lt * ETH_balance)*SP) / (her_token_lt/token_lt * token_balance), digits = 5) ==
    round(0.2/0.8, digits = 5))

#sell ETH (buy tokens)
V = ETH_balance^ETH_weight * token_balance^token_weight #update invariant (should not change from swap)

sale = 5 #how much ETH sent to contract (swapped for tokens)
old_token_balance = token_balance #store for calculation below
ETH_balance += sale 
token_balance = e^((log(V / (ETH_balance^ETH_weight)))/token_weight) #update token balance according to sale
tokens_received = old_token_balance - token_balance
println("ETH sold: ", sale)
println("tokens received: ", tokens_received)
println()

V = ETH_balance^ETH_weight * token_balance^token_weight
SP = (token_balance/token_weight) / (ETH_balance/ETH_weight) 
println("V: ", V)
println("SP: ", SP)

#Verify that original staker still has originally-weighted assets and balances (see above for values)
#balances will have changed b/c of swap, but weithed ratio should remain constant
show(round((my_token_lt/token_lt * token_balance) / ((my_ETH_lt/ETH_lt * ETH_balance)*SP), digits = 5) ==
    round(0.3/0.7, digits = 5))

println()

#Verify that second staker still has originally-weighted assets and balances (see above for values)
#balances will have changed b/c of swap, but weithed ratio should remain constant
show(round(((your_ETH_lt/ETH_lt * ETH_balance)*SP) / (your_token_lt/token_lt * token_balance), digits = 5) ==
    round(0.4/0.6, digits = 5))

println()

#Verify that third staker still has originally-weighted assets and balances (see above for values)
#balances will have changed b/c of swap, but weithed ratio should remain constant
show(round(((her_ETH_lt/ETH_lt * ETH_balance)*SP) / (her_token_lt/token_lt * token_balance), digits = 5) ==
    round(0.2/0.8, digits = 5))
