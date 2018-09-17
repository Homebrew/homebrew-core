class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/2.2.tar.gz"
  sha256 "25607db12f466ba88a1454ef8b378e0e9eb59adffad6baa4b5610859a102a5dd"
  revision 1
  head "https://github.com/ntop/nDPI.git", :branch => "dev"

  bottle do
    cellar :any
    sha256 "ec776ec7d02f4c5fd2466ddfe9ba18b0418869ae26998f775f3b2424d2b13857" => :mojave
    sha256 "5d746b20ffc8833427d8ebd6baa6778aaa33eadec316e759492d81a3e08a9511" => :high_sierra
    sha256 "f93f3b4ee594ca14433be337b9afdcc830cdfcceb944a77973da81904c2e0d4e" => :sierra
    sha256 "95310ac78ec0568667d533dfdea8f6338a44bc04d1de8d0e9bbefd5620a8cdb2" => :el_capitan
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
