class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "http://www.ntop.org/products/ndpi/"
  url "https://github.com/ntop/nDPI/archive/1.8.tar.gz"
  sha256 "cea26a7f280301cc3a0e714b560d48b57ae2cf6453b71eb647ceb3fccecb5ba2"

  bottle do
    cellar :any
    sha256 "8aa12f9a224a380a958ffca3484ed6115512d534a73e9e1c4ea12454884f2c38" => :el_capitan
    sha256 "7bc4d4b6b2c7c9a28fdc1755d4a66f67768200fd8e9dfd5bc161d799199fb534" => :yosemite
    sha256 "fd2762a77e68415e14c3fb8a1da10801c38e1cdf1f0bbe0780c0e57f54862df5" => :mavericks
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
