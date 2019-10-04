class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.17.1/newsboat-2.17.1.tar.xz"
  sha256 "c1ebd24b017173156e817a1a3dd1d982808dec30a891e1f487806e5f86171997"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    rebuild 1
    sha256 "66aa9b1c98217bfc6d52b658501896bfa8e5d48048f553042838b22035508bc1" => :catalina
    sha256 "cb49362b332f540d1df86f78385f98d99ddd0740d781764641ba9069d7e6a87a" => :mojave
    sha256 "872d0d0553c67df6d9b095a173946cd1a357721e97037c20802f86550d2e0514" => :high_sierra
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
