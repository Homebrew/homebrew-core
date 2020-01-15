class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.18/newsboat-2.18.tar.xz"
  sha256 "f23932c0226ec3f69eac7668da444e73175048498e15e9d773451648b2cba4b0"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "3ebdaac8a35ae290af7adffe737bec71f1ca4d96d58acc352a6d926eab3dc1ed" => :catalina
    sha256 "3b5461262a95b3c29cd7fce17c0c7db2116dccdcbb9bdd4e9e912b5890279737" => :mojave
    sha256 "9e3ce4ad4a7230aa6356651c7dca731d56366bba7ba42e73eeb8d3dfdbf8ca45" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    gettext = Formula["gettext"]

    ENV["GETTEXT_BIN_DIR"] = gettext.opt_bin.to_s
    ENV["GETTEXT_LIB_DIR"] = gettext.lib.to_s
    ENV["GETTEXT_INCLUDE_DIR"] = gettext.include.to_s
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
