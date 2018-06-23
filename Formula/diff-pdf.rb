class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 31

  bottle do
    cellar :any
    sha256 "1c3f935573f83f451c6b584e357ee69bec9c5bafd00ff29324b4233bf776d951" => :high_sierra
    sha256 "c6b89e9e450202ad45152b5f6bb78416484ca62e7e50ebdc4803c90ca96e8b81" => :sierra
    sha256 "3f54a8562101f2e5377b1dd89f466578a94ad0f28e441de34a07e3da09662171" => :el_capitan
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
