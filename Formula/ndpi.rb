class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "http://www.ntop.org/products/ndpi/"
  url "https://github.com/ntop/nDPI/archive/1.8.tar.gz"
  sha256 "cea26a7f280301cc3a0e714b560d48b57ae2cf6453b71eb647ceb3fccecb5ba2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "78dbdb1b80893d2f923a08ba73606f58b574e89556ead5376eed055eac5c1b0d" => :sierra
    sha256 "9cb6f2b80b5429b9e4b7a5d7639ceb49a834a8771088b34253bb687c1cb61ed0" => :el_capitan
    sha256 "556bf60eea0740addddc211f2bf7a4627b91da6ec1412d43a9054c2d1d243d71" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-c"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
