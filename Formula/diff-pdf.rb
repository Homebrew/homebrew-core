class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 19

  bottle do
    cellar :any
    sha256 "8ffea2d120fde8f23b054323edefd6493d37ea53c8bb811101c30c942a597d89" => :sierra
    sha256 "c85d2c1e587a0a3a8aee88dce4e1e9d958abc877dda172d8809599b6f48aa2af" => :el_capitan
    sha256 "d306f1a134c0a222f7d406811a94dba3b218927441cc9d4f75cc81516c0c0c17" => :yosemite
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
