class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.23/newsboat-2.23.tar.xz"
  sha256 "b997b139d41db2cc5f54346f27c448bee47d6c6228a12ce9cb91c3ffaec7dadc"
  license "MIT"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 arm64_big_sur: "096bfe4251f6d377dfb23ead04216d44bf1c569a33d2777436d201492c13a349"
    sha256 big_sur:       "70d56cc3656fc51a42d53b70860c0de373e9b3792f20aefb0452d03e7213bd52"
    sha256 catalina:      "a32a919a3a00dc668a3534e5711b393779827409662d92955ae14b4f98e059b4"
    sha256 mojave:        "83ec08468bdeadf15000a2ed60a79930144be95bd7022dbc2efa2e53803d47e4"
  end

  depends_on "asciidoctor" => :build
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
    assert_match "newsboat - Exported Feeds", shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
