class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/3.4.tar.gz"
  sha256 "dc9b291c7fde94edb45fb0f222e0d93c93f8d6d37f4efba20ebd9c655bfcedf9"
  license "LGPL-3.0-or-later"
  head "https://github.com/ntop/nDPI.git", branch: "dev"

  bottle do
    cellar :any
    sha256 "2bd1baa2228b81e20a2048551cdb36f0baae71d59f5c8101a7b7eab697283703" => :big_sur
    sha256 "077be45cfe6beb92e2ffa5fad72f6ff5aa09ce438dbf74d90eb253b3b54e219e" => :arm64_big_sur
    sha256 "f43c4bc1a08e5ee659fc1aee47382af2524e8b86e6a4be73a4997e11a6493068" => :catalina
    sha256 "26cc3ab8ae4ef3222e5f64cc9950a19517afb9bf3f8eb39b3454ef9bf6330917" => :mojave
    sha256 "42896776ab7d56623abd32ebdd31bce2ef6620437829394533c97021c5fa7783" => :high_sierra
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
