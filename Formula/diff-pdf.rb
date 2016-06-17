class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 11

  bottle do
    cellar :any
    sha256 "7e0eb909342b37f20a7627606f52f9dca1590d86658bd151295e5571056294f8" => :el_capitan
    sha256 "cdafcf547b4ee9d3dc16dbd73bd522d0327f17c93a14d420df1140f75e510a5e" => :yosemite
    sha256 "119e773e1d94767e7b9ffe1e8478eb5d742bc52cb0f2d50788922d405f523e2b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on :x11
  depends_on "wxmac"
  depends_on "cairo"
  depends_on "poppler"

  def install
    system "./bootstrap"
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
