class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 24

  bottle do
    cellar :any
    sha256 "ac7140b8a7842e69bca5ac080852e716b7ba6f93a5aed3766a6f5bb9e5a4e943" => :high_sierra
    sha256 "9762c944d71030ecc697f6e010c1a1e742987a28d93f592c93ae6660b203286d" => :sierra
    sha256 "d28c851466ff8342836c5262853ba10fecf340d1451ee0940ba5b6f54883202e" => :el_capitan
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
