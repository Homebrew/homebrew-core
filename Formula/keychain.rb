class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://build.funtoo.org/distfiles/keychain/keychain-2.8.5.tar.bz2"
  mirror "https://fossies.org/linux/privat/keychain-2.8.5.tar.bz2"
  sha256 "16f5949b606691dea6e1832a77e697b8c0b2a536abfbd29e3a3f47222259c3b2"

  bottle :unneeded

  def install
    bin.install "keychain"
    man1.install "keychain.1"
  end

  test do
    system "#{bin}/keychain", "--version"
  end
end
