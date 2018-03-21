class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 28

  bottle do
    cellar :any
    sha256 "35aa2a2faf16f545820e2018b7ca8fa5df319e66a0b0cca97343137f8464b860" => :high_sierra
    sha256 "7f82cb8634fbd69a79bb98c7808a3f5eff9c4cd902385a2b073675cb668607cf" => :sierra
    sha256 "5be786683b9524bd576a02b501693d0d998ad273e18a28dcc631e69c1ce8c2cf" => :el_capitan
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
