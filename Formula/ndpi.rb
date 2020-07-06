class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/3.2.tar.gz"
  sha256 "6808c8c4495343e67863f4d30bb261c1e2daec5628ae0be257ba2a2dea7ec70a"
  license "LGPL-3.0"
  head "https://github.com/ntop/nDPI.git", :branch => "dev"

  bottle do
    cellar :any
    sha256 "e8649c1478461fbd5a4a3944e4b5a34d6cd1ba018e8a3882204881b46acdff8c" => :catalina
    sha256 "fa7f7c5f759f6bda7e93965362ce4ce221519972881f07b66d4de1ff04903934" => :mojave
    sha256 "a36d911971b305580ae10b2275c50a4eca2a6aef0b79cdeb27045e49f708e41e" => :high_sierra
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
