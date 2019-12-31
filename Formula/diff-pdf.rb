class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.3/diff-pdf-0.3.tar.gz"
  sha256 "8f1beb45d48fecfb09c802e95154ad9b8d4b73e90796eaf7ab835f107b495da0"
  revision 9

  bottle do
    cellar :any
    sha256 "07e93d063978fa6c5de2fe0356e01dc02e0afedbf858b55de0a5d954f33175db" => :catalina
    sha256 "6fd7d0185946ebc5eb5842bc64322574fd1b9a6798c26016e3a6a66999752a1c" => :mojave
    sha256 "a174e057f8e7c14d7fb7636a401876426e97a8c5858fea70eb9ffe5575a84202" => :high_sierra
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
