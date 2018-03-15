class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://build.funtoo.org/distfiles/keychain/keychain-2.8.4.tar.bz2"
  mirror "https://fossies.org/linux/privat/keychain-2.8.4.tar.bz2"
  sha256 "1746dac19f565a1489b5a8ee660af2d7097f44cb5bede3e9103782056592ae6b"

  bottle :unneeded

  def install
    bin.install "keychain"
    man1.install "keychain.1"
  end
end
