class Frobtads < Formula
  desc "TADS interpreter and compilers"
  homepage "http://www.tads.org/frobtads.htm"
  url "https://github.com/realnc/frobtads/releases/download/1.2.4/frobtads-1.2.4.tar.bz2"
  sha256 "705be5849293844f499a85280e793941b0eacb362b90d49d85ae8308e4c5b63c"

  bottle do
    sha256 "1f930caa2b88fb90d0cc1938397be4e66e8b43835773ddbedff9c891fae12e59" => :mojave
    sha256 "af5706f2616c0be86e6cfbed57ba560fa2bbdcb8b59c769c0c3e800552d51829" => :high_sierra
    sha256 "d3c660cd331b2a35ef36f55210e50e05e98d06fe3e5d606205ba63d226625f2b" => :sierra
    sha256 "cff84f9389281d4ca9c9aae8ece93384aec506ea9601e1c3d637df82776afce3" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /FrobTADS #{version}$/, shell_output("#{bin}/frob --version")
  end
end
