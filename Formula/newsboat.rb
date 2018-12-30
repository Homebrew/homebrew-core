class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://github.com/newsboat/newsboat/archive/r2.14.tar.gz"
  sha256 "57176071b0c777ddba237f95f684e36bf2ddf271e84ac5c9e3eec8f1afc0b133"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "a9ea0ec030fa5247224ad2aaf39d355d1b89251e1786d9bd457e1773aabd9478" => :mojave
    sha256 "3b626ed21880078c5de05fd69e7228d45b30427e88b05ca797f5f48c1319a33a" => :high_sierra
    sha256 "c150c11f1f1d6b500e863403ab3d6fda66af62fc6507edeca8fbfbc1f1577107" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
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
