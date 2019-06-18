class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 3

  bottle do
    cellar :any
    sha256 "33ad5dfb6f53d8e25ca4b56b7082384289b818f6c0263e7c040819c9323d1f3c" => :mojave
    sha256 "c9c3a218c2e99bce440b6ea3dded335ecac25456c267427bbe9d9ab5f5bc014b" => :high_sierra
    sha256 "3a0e50a68210ddc87b93d9c298a449bf3885668187879c0979a9be2c48b877ab" => :sierra
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
