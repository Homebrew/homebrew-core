class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 1

  bottle do
    cellar :any
    sha256 "f1edd4cbae81b2d453d8b0f6c12304fbee70a03f24baf0481a982cc66f7b2530" => :mojave
    sha256 "ee6a016e55555ef5c7e96553278496fbffb8c177e0e5207bac2843c2d9d41079" => :high_sierra
    sha256 "7086652e48ad3a1b77ee1fa665bcc46f3c024070c8908ae4c84ef4518d016b59" => :sierra
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
