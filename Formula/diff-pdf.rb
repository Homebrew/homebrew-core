class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 30

  bottle do
    cellar :any
    sha256 "d61aee37ac17b044090ca1ef57cc34020e212c51f0a2e8125dd9bb8c099cc857" => :high_sierra
    sha256 "35454bb7deda741dca5168fce87d9ed3c8d32f24a6d8a1875a186b24ce44da7b" => :sierra
    sha256 "6ebfd7c0aacf66731ec8099cf3b544507a4da89b903132d6c5f48857791d9a6b" => :el_capitan
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
