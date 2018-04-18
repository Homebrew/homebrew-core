class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 29

  bottle do
    cellar :any
    sha256 "612be87835450b42bc13dfc8bc996a8f7d8bae75c255f322a8bbc4c69eccb2a9" => :high_sierra
    sha256 "c349724e7c18707efcdc9d3777ed0a739578579afcdf007970ae1d7870052171" => :sierra
    sha256 "67aebcb0b22f4f66f7c25544e75c6b3d31ca01434df855350cd4629ae2491986" => :el_capitan
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
