class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 21

  bottle do
    cellar :any
    sha256 "e17b6c8a62087a85bf91352e7d91a44b1087b429a737501695140c1b4ee34de4" => :sierra
    sha256 "6dedbf26ed0fc825f7285617bcf880bc8f37d021b7992069fbc782a4540123a5" => :el_capitan
    sha256 "f48ccf0765e27f62cf5e2e72b5b613507c2a6127d88931468700aa6524af3fac" => :yosemite
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
