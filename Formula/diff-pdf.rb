class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 12

  bottle do
    cellar :any
    sha256 "dd2c53be804373e5b35fff0195a95a761c1dcecd7e783e707ad9569a9b4ddae3" => :el_capitan
    sha256 "52ef00218c283b79fbf78738be1c01942a7a8254ba3ec367d1b78c3340f84a5c" => :yosemite
    sha256 "dc705f9eff881d1b9386515cf278c6c03c7e0dba6810fcb34677bd0485d773b5" => :mavericks
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
