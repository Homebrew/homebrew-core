class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 33

  bottle do
    cellar :any
    sha256 "488f358a791a7531a838697fa4dad6a9fc94b256af15b3c1f83469c059e4ca8f" => :high_sierra
    sha256 "247b718e5474c0186c9c3a22fe63dc9b695950c4b30e916b15dcd036263c85c4" => :sierra
    sha256 "cbdf6acfa837170a52d0f904158a882ff17b4bbc646faed7082d1dc4169e8db4" => :el_capitan
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
