class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.0.0.tar.gz"
  sha256 "12aebe2c4a0524997c473cf17cf24804814008ea31785f03587d792698acd792"

  bottle do
    cellar :any
    sha256 "39c0963ed7c3a456615c91a22d77293ba5f165260a305f88a9f4ba5c358510ec" => :high_sierra
    sha256 "5dd04829e40c9f4584c8c7ff16326bc469c20410dcd32f18f51a98a30d3036dc" => :sierra
    sha256 "40d73c34e136143835dead424d662f4f13669c0fd9f3801dd9cb17613a8bdbb8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
