class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 7

  bottle do
    cellar :any
    sha256 "889d4938538d254d0b6e4d1438d8b361e038da3b92b00377686ab599f042accc" => :catalina
    sha256 "5cf188696cd121f90dc5ea99796bd993718c058f6827aaa17d11356486378779" => :mojave
    sha256 "44aa69f3298817c949621ea5af607bf08e8699c2f973e71fcf20fa5979c81d35" => :high_sierra
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
