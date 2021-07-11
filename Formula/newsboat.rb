class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.24/newsboat-2.24.tar.xz"
  sha256 "62420688cca25618859548d10ff6df9ac75b9cf766699f37edd3e324d67c6ffb"
  license "MIT"
  revision 1
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 arm64_big_sur: "9922dbecd7634ea61585f74f49f4775db60c7dcbc76a3a246c79ccb9f59a8335"
    sha256 big_sur:       "e9bfb69e519287ae177ed85f541ab52935b9ac17f185d60dd781f80da4cb87a5"
    sha256 catalina:      "3b0d83f8cbbb313d096f707c75bf533a770401f15f682e40e47f5f56fe05c718"
    sha256 mojave:        "c45ac94247954d6122b78d721856a798bc47b78d59256eed38faa7f11dc5fb2a"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "xz" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "sqlite"

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
    assert_match "Newsboat - Exported Feeds", shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
