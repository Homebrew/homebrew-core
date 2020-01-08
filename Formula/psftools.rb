class Psftools < Formula
  desc "Tools for fixed-width bitmap fonts"
  homepage "https://www.seasip.info/Unix/PSF/"
  url "https://people.phys.ethz.ch/~myczko/debian/psftools/psftools_1.1.10.orig.tar.gz"
  # Previous URL (upstream default URL) has changed checksum:
  # https://www.seasip.info/Unix/PSF/psftools-1.1.10.tar.gz
  sha256 "1bc03214a29c4fc461a7aa11b9a3debde419b1271fa5110273ded961774e2b6f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "45dc312102cc19efb4f884e2815e7429958be40fba454973de6d64783b379862" => :catalina
    sha256 "6206419f9571de1d719e48ea41f352e7a19ccf93e22f67949d39f6407117ce5e" => :mojave
    sha256 "abd4076ee669f51d13339c64d609db42543ba04268b9e3e8e79d5c4ad3dba397" => :high_sierra
  end

  depends_on "autoconf" => :build

  resource "pc8x8font" do
    url "https://www.zone38.net/font/pc8x8.zip"
    sha256 "13a17d57276e9ef5d9617b2d97aa0246cec9b2d4716e31b77d0708d54e5b978f"
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # The zip file has a fon in it, use fon2fnts to extrat to fnt
    resource("pc8x8font").stage do
      system "#{bin}/fon2fnts", "pc8x8.fon"
      assert_predicate Pathname.pwd/"PC8X8_9.fnt", :exist?
    end
  end
end
