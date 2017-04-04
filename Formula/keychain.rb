class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "http://www.funtoo.org/Keychain"
  url "http://build.funtoo.org/distfiles/keychain/keychain-2.8.3.tar.bz2"
  mirror "https://fossies.org/linux/privat/keychain-2.8.3.tar.bz2"
  sha256 "d05eb924efcaef78eddff8e3190154a39778f0eee4f90362528c81ad8dadde56"

  bottle :unneeded

  def install
    bin.install "keychain"
    man1.install "keychain.1"
  end
end
