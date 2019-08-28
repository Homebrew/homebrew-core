class Dmg2img < Formula
  desc "Utilities for converting macOS DMG images"
  homepage "http://vu1tur.eu.org/tools/"
  url "http://vu1tur.eu.org/tools/dmg2img-1.6.7.tar.gz"
  sha256 "02aea6d05c5b810074913b954296ddffaa43497ed720ac0a671da4791ec4d018"

  bottle do
    cellar :any
    sha256 "c7989c8d06b954b4d9601e5d550d1767ac0b26d48db71160dfa63bcc2135e0e1" => :mojave
    sha256 "9c4554961fd123caa17225fccc95f5b56bc554748d8353ef2ced14c350c0b1ef" => :high_sierra
    sha256 "d106c5d7e6b759ccceabda3d54ebc633ed5367f9d9fdfeff752ab1f8574a7ffe" => :sierra
  end

  depends_on "openssl" # no OpenSSL 1.1 support

  def install
    system "make"
    bin.install "dmg2img"
    bin.install "vfdecrypt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dmg2img")
    output = shell_output("#{bin}/vfdecrypt 2>&1", 1)
    assert_match "No Passphrase given.", output
  end
end
