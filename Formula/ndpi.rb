class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/3.4.tar.gz"
  sha256 "dc9b291c7fde94edb45fb0f222e0d93c93f8d6d37f4efba20ebd9c655bfcedf9"
  license "LGPL-3.0-or-later"
  head "https://github.com/ntop/nDPI.git", branch: "dev"

  bottle do
    cellar :any
    sha256 "51abcf1acf93e23b6c9ac4394546b3c4cf10728ab4ddaeeedfb1113652c4df5d" => :catalina
    sha256 "022d0450ad519fb8bab4399ad40cef22421162b44b138e4279cdc1588f49c985" => :mojave
    sha256 "e5dd2608031a9fee47f714c8795b013c645c05ad573d64fdd603accc9c878a1a" => :high_sierra
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
