class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/2.2.tar.gz"
  sha256 "25607db12f466ba88a1454ef8b378e0e9eb59adffad6baa4b5610859a102a5dd"
  head "https://github.com/ntop/nDPI.git", :branch => "dev"

  bottle do
    cellar :any
    sha256 "5c3eb3bebc87fa5d005aab71f15227122dc4cc37f997a9867dc447f533798f64" => :high_sierra
    sha256 "bd5611ea958ac8e8c1e87a7cae4aba3a10bdacf8570fb6efc9e2d78a8d4a6bb6" => :sierra
    sha256 "b39ffc60028e51156dcf5891c6fab0b1c717c9a9664bca7eadeec5d9aa4c170a" => :el_capitan
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
