class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 18

  bottle do
    cellar :any
    sha256 "b6a46631c77e0cbadb4c8f3d5f64dbf62aaf30472e5c698998868ea73c0aa29d" => :sierra
    sha256 "f1d16f4b47ea042e14cadcf8a5618e07e905e05d18a7fd69fe717074624ccd02" => :el_capitan
    sha256 "32d13e04c380093038a4ee0a9d3967f01b5ea85d44c61aa0ba50a1a22b5f68a3" => :yosemite
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
