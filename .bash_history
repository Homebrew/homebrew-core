ssh-keygen -t rsa -b 4096
cat id_rsa.pub
pbcopy < id_rsa.pub
cd ~
vim ~/.ssh/config
brew update
