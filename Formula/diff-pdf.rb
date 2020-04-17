class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/releases/download/v0.4.1/diff-pdf-0.4.1.tar.gz"
  sha256 "0eb81af6b06593488acdc5924a199f74fe3df6ecf2a0f1be208823c021682686"
  revision 2

  bottle do
    cellar :any
    sha256 "15dc3bf1b1c100ddd34ece057d16618e61cb19f3c238360da17ec5342bfa373c" => :catalina
    sha256 "319fc0aaca6c5208ee55b427aad2a5929535e68bcf0818856bc440b338c05241" => :mojave
    sha256 "ceb17fac51abe97a7436fee39b00ab77adc9d1821e886fcfca87d39672bbab9b" => :high_sierra
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
