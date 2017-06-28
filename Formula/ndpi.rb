class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "http://www.ntop.org/products/ndpi/"
  url "https://github.com/ntop/nDPI/archive/2.0.tar.gz"
  sha256 "90ae6e4de83bda5bb7405207020c1e0be364841510fdf5f0a2d48974e1a3fbcb"

  head "https://github.com/ntop/nDPI.git", :branch => "dev"

  bottle do
    cellar :any
    sha256 "e0b6695cab0cadeac7383e7a86fae6795e5def53411ae6167668ac6b8f97231b" => :sierra
    sha256 "ed0fcd50c950d724e1b32158c09832e0e04c5918b5e42d8131dd7f09ee655002" => :el_capitan
    sha256 "71c9b7939c80c3854944d81f308e519f92e9f8d0e2a65e5a30ac78222c54d15d" => :yosemite
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
