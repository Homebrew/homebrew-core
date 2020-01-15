class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 9

  bottle do
    cellar :any
    sha256 "317c1eeb665dd68c83de5ae56c6dc4663c77ffff65f6dd9a195a5d5613e12bc8" => :catalina
    sha256 "e813dc9dcde2d161ed66098b42433c29f39936d4ada1a8e2fdf1f7db57ad389a" => :mojave
    sha256 "81fc9ff824c7e56dfded0950272b70e92ccf16d3983bd1534064e62e5afb82da" => :high_sierra
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
