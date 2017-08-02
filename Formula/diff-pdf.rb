class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 21

  bottle do
    cellar :any
    sha256 "94adb4c772993f292a9ba8922125225019f40d3388aa5927feb1b8ae376fe3dd" => :sierra
    sha256 "df77b5a99eb72817374a2b44374f8bd4a981ddf3f5bd50d40fd44276744cc521" => :el_capitan
    sha256 "074805671db485da0e094fae3de45bde2d3efab1569b392e8caf34bc411b1c58" => :yosemite
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
