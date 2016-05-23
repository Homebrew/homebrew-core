class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 10

  bottle do
    cellar :any
    sha256 "4e518ae3502951bc5423966206b4d9c65c0f685ac5ad2a0715cf93ab5ce9c64e" => :el_capitan
    sha256 "44e3fd4479c448d685d82f59753e0e8bd5de2795a0fc1f5d46a8ae8d0dc0d319" => :yosemite
    sha256 "3d08ecd0035cf2d10ab40b3fd40116c628a4027a230d1f114e90ce69a783c988" => :mavericks
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
