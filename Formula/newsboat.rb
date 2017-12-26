class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://github.com/newsboat/newsboat/archive/r2.10.2.tar.gz"
  sha256 "e548596d3a263369210890f46f146a6a398bd2b1973f94167e5614dee58ab7aa"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "d58d7d7bba90312e4a6d85a3f04b8f5c6f0199cfaed39b968c2d60c953e92bd5" => :high_sierra
    sha256 "456f0ac37b014087f62acefb304121f662d5ff87de13e46308203257f4d4cef5" => :sierra
    sha256 "aab8c0a125ebeca090c7f6e9c39438a5c43353bfed8b62a6f42b6f03d662d1fc" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  needs :cxx11

  def install
    ENV["XML_CATALOG_FILES"] = "/usr/local/etc/xml/catalog"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
