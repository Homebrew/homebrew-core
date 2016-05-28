class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "http://www.ntop.org/products/ndpi/"
  url "http://downloads.sourceforge.net/project/ntop/nDPI/nDPI-1.8.tgz"
  sha256 "f490137a7387b69d0d55e990f2150b86d7b5eaae870e5326e8c2f18c17412443"

  bottle do
    cellar :any
    sha256 "05053767fc3c70557745c348c7352e7c2716c040ca54c5cf8d5306167c878fcb" => :el_capitan
    sha256 "34c0269039a0079820eeed862daa28158d9291f73f640a9415da60746d69a662" => :yosemite
    sha256 "a2af4dc62c24313593b3a20e45ca9d2d49f8efc0ea5e52fd064001ea441b93e4" => :mavericks
    sha256 "1bb200268a4d9df9bbe5d33bc773ee3bcf4b5d4fa00c76a040f16318438c284f" => :mountain_lion
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
