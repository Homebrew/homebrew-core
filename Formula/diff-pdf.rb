class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 7

  bottle do
    cellar :any
    sha256 "83d3d4c14664c8f4dfed2aa08ee795e0a791e742de9cc17dfefbcc448f0aa82f" => :mojave
    sha256 "371a5f3452bc778172744a54490b1510d9058f24c86faf95a4eb6bba72603cf3" => :high_sierra
    sha256 "f2405a671784efc1abec27952ef302676c924152df740cce55a375fb84b258de" => :sierra
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
