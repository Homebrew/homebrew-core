class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 32

  bottle do
    cellar :any
    sha256 "3bb76335ff0e6f9c53a2529638157a1473097908ac052a1a69e7b066251c06d8" => :high_sierra
    sha256 "e2803bdd43f5f318c0c7e18e650adf1e32d84652c202d1593dbad2405a5720d4" => :sierra
    sha256 "65c08db3a51ea6d91a9f0d119e74bfbd5b83b1fc846e4f94e450815ac2e3fa4d" => :el_capitan
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
