class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://libofx.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libofx/libofx/libofx-0.9.14.tar.gz"
  sha256 "b82757bfa15b27c02fb39dfd017cdfe5af51a063ba15afe495dd1b7367ff290a"

  bottle do
    sha256 "a9dfe2ec7099410f4bd59c1add916c0f08af6e40ca87f7bfed779fb5215036bb" => :mojave
    sha256 "03468f12a56e1d6d7ca8d2a3b1826d41a173363431e4ecc6ae0aa684fd2f6d56" => :high_sierra
    sha256 "eaee8c1c4986358a0b15b801d76e0b976b351ffdf230e32e5fff98606b65284f" => :sierra
  end

  depends_on "open-sp"

  def install
    opensp = Formula["open-sp"]
    system "./configure", "--disable-dependency-tracking",
                          "--with-opensp-includes=#{opensp.opt_include}/OpenSP",
                          "--with-opensp-libs=#{opensp.opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "ofxdump #{version}", shell_output("#{bin}/ofxdump -V").chomp
  end
end
