class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 36

  bottle do
    cellar :any
    sha256 "66aec62a82d1cce1fa5e01afb6da77999c27725aaba3fa4be53973b7cfb18652" => :mojave
    sha256 "329fa3993be301e27023448371c2251399d18d2838185b11cae3ba9b15be5325" => :high_sierra
    sha256 "11607e8bffb17a33ea9ba8227dc7beaee284d7291da3b5f60a2837c812d9b3a5" => :sierra
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
