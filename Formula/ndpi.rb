class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/3.0.tar.gz"
  sha256 "69fb8003f00e9b9be3d06925398e15a83ac517cd155b6768f5f0e9342471c164"
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

    # temp fix to move sample files, reported upstream: https://github.com/ntop/nDPI/issues/826
    mv sbin, share
  end

  test do
    system bin/"ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
