class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"

  bottle do
    cellar :any
    sha256 "99c422262ed06f2eee9e83301d3824cad30d2d258fe12cf5f808077674088531" => :mojave
    sha256 "22c11f6e271a78b1ab6711a2a6188b7ccb0a66ee1eb50374d95ee6a6abdfac62" => :high_sierra
    sha256 "5d5919e417e3c9fa78a131dc0a6771f0a2bca3d54ddfad6222ac07c85c6af31f" => :sierra
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
