class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 34

  bottle do
    cellar :any
    sha256 "67d7a15100d30a7564af8c23f157180043a657df7571fbd37f2a5f822c9970e2" => :mojave
    sha256 "803da9c4f492d5b81acbb6d89688a37e197b4bfdf3bc8159e9bea85e1c68e31c" => :high_sierra
    sha256 "f7b538c741b7c52a727bdca9b72edf8d07a33cc0d9cc9bab5e9edea5f9b2a623" => :sierra
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
