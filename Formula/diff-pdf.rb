class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 19

  bottle do
    cellar :any
    sha256 "ba7c7682914237431b7744f96c51a1aa05d474c310a6ed99db072349b0a8e9f9" => :sierra
    sha256 "b1a2a0ab63b88220cb793463aebc6e1963d539a52ceaa651c4b97bcdcbc4f353" => :el_capitan
    sha256 "663429c7d933f645fd91111452e2e426a016026ac19e643f5f247b24cd95ced3" => :yosemite
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
