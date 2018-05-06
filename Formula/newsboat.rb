class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://github.com/newsboat/newsboat/archive/r2.11.1.tar.gz"
  sha256 "0c48ec60e1abafd7b62cf8e376eff9e92dcb7bbc6e7dfed9b9ac141853d826d8"
  revision 1
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "eb87047a5ea10e1224854ee0b12c192d2babd4a13e74f5495e7efaec29ad0368" => :high_sierra
    sha256 "7d78913b0b6b0373c5e43e6dcfa96df7e347792e4aa7c7878b11a802114e2e76" => :sierra
    sha256 "b9e794bc4654bebd68a606f148d225dc68e5e7cc8e6b660c03bbb56af3851e09" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  needs :cxx11

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
