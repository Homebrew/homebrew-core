class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 39

  bottle do
    cellar :any
    sha256 "5abf9c0b74934181f49abb0085a7942313d96e5024ee55838a881cd795f7952d" => :mojave
    sha256 "56214d2101a95f16935f9a30edf3dd1569fd54f20436fa1a05226310b0ab7aeb" => :high_sierra
    sha256 "c6ff745d7955190c1af4637987afa00540cfeca71f4ab5826581c0dd99d4fecd" => :sierra
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
