class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/3.2.tar.gz"
  sha256 "6808c8c4495343e67863f4d30bb261c1e2daec5628ae0be257ba2a2dea7ec70a"
  head "https://github.com/ntop/nDPI.git", :branch => "dev"

  bottle do
    cellar :any
    sha256 "f23fa826dc6129330d1b41bdc539030f9aaed08808a0c1069fe7f62f584bbdd5" => :catalina
    sha256 "9a3a2188a213e465ae28a4157cf55ffd41cf063a4d5a1fce8303a628e156d170" => :mojave
    sha256 "dc46177d3969758f0ddf79ea82b48861cccd11d2183f0533ebe3cd703b276a16" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
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
