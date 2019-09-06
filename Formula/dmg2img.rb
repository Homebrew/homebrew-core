class Dmg2img < Formula
  desc "Utilities for converting macOS DMG images"
  homepage "http://vu1tur.eu.org/tools/"
  url "http://vu1tur.eu.org/tools/dmg2img-1.6.7.tar.gz"
  sha256 "02aea6d05c5b810074913b954296ddffaa43497ed720ac0a671da4791ec4d018"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a27f0b22acaadf41ced2a3ebe6d8772b6ab85008499bcd409107813b07f06b78" => :mojave
    sha256 "60b7c5433f65d217530c643ddc4d0299b864c557f6458e72e1f8c6d281b42531" => :high_sierra
    sha256 "2de198aa4f3990f7e00d71853fbd355aed65ed7f0147fcd8e9e16318c8b7edd3" => :sierra
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
