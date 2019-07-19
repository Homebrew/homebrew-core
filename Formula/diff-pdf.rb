class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 5

  bottle do
    cellar :any
    sha256 "19694d7734b9ff9aed0667862fe60a0885f20324da8cc02c7d73121a291f25bf" => :mojave
    sha256 "f14b0be6dd6116200b4cfb30e9d2aa95029a7ae26dfbd3046aeee9b4a052ac90" => :high_sierra
    sha256 "a2bc426067df2ff57102904de7e9b464e845f84f56ce6dc6dc48618f829e134a" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "poppler"
  depends_on "wxmac"
  depends_on :x11

  def install
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
