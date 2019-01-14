class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 38

  bottle do
    cellar :any
    sha256 "a82824b3891a5f4d39f3651b6f2b5b0a7bf31ad373f9dcce3eaf2273dde96d35" => :mojave
    sha256 "069f5f286f4505d28c3842949e3162674d02783ebb1f67707f80be4aa958baa3" => :high_sierra
    sha256 "1425a93d9717eafb648418da582c85f647e8aad203416c0e15f85791768bd7b8" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxmac"
  depends_on :x11

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
