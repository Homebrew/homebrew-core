class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 2

  bottle do
    cellar :any
    sha256 "4f95eaee081c5fb0e9ba5b58d690b079fd565db710fb4a1d786acf0b260ee0b2" => :mojave
    sha256 "df58967e8377bc9ea29118ec6047e7bd39372c52d0d3cd3d5ea8e80aba31a7cd" => :high_sierra
    sha256 "a0149218e423851ee03f43099ce9c4339a16f2cdf7536bb2c01eef41b7660df8" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxmac"
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/diff-pdf", "-h"
  end
end
