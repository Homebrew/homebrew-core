class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 26

  bottle do
    cellar :any
    sha256 "5e84f237cb15af785cc52706ac1bb41fa4863a560b62d9e6cbc182f8ac3de700" => :high_sierra
    sha256 "5824a149553899f21ca6def3d99a09267cdb309faf054624f733722e3de1f711" => :sierra
    sha256 "287895d965b49d8021b2f44c0fcc13b672ec90141bc7bdc481b8ad57ab687073" => :el_capitan
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
