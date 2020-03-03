class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 11

  bottle do
    cellar :any
    sha256 "f8c11262bec0d6d5e59791433e47432bd1f82df326158c72bf0ec8a318a00e42" => :catalina
    sha256 "fcfb0e8e2ba9c83f25a71733b264d674a8ed2605131f9eaeba7f5857ce1f5a03" => :mojave
    sha256 "901e5f6abb6f0ebaa1a6f03f0bae4832eb9f417c8012dbfd03b57676a833f937" => :high_sierra
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
