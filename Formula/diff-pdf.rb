class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 15

  bottle do
    cellar :any
    sha256 "7940e298466394c32c5f945515e939dbdd1b2238f8ab98d879eaa4f57145d453" => :sierra
    sha256 "ca165f7eef57e0590975475ad6b709076593d340086bbc8ad3ec5cfc8f92fecf" => :el_capitan
    sha256 "20b0a594c7a20427f5dd6545ee936092314aaccc450e3569990f746e08c20fa4" => :yosemite
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
