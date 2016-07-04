class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "http://www.ntop.org/products/ndpi/"
  url "https://downloads.sourceforge.net/project/ntop/nDPI/nDPI-1.8.tgz"
  sha256 "f490137a7387b69d0d55e990f2150b86d7b5eaae870e5326e8c2f18c17412443"

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
    system "#{bin}/ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
