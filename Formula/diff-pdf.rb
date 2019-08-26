class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 6

  bottle do
    cellar :any
    sha256 "f573296de6ce419d29af0239de0cfa2f85b6f44fb4fb6045798c2dbc1a886e65" => :mojave
    sha256 "9f5e93aa78202545c25163ba87c2b8d6108a936ff4723a0e6aeb06edd148baff" => :high_sierra
    sha256 "6e44afab0e0d096c4b0fe94c6d38d8d91ad6c4838ed3ed7873f3cf5b2ac216ff" => :sierra
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
