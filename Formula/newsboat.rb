class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.17.1/newsboat-2.17.1.tar.xz"
  sha256 "c1ebd24b017173156e817a1a3dd1d982808dec30a891e1f487806e5f86171997"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "a5db87ee69b05dff690574d202d9f8682c98f1f9fdba778da9e0cc0ea331570d" => :mojave
    sha256 "05003ff5da81d4536f1b59fbc5d4760780b19e83462adcb8586084a9ac5d5bc0" => :high_sierra
    sha256 "f6385d334363aa461717c874ed0901f70d2aa9ee1415637c33de3fc09e61df1e" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"
  uses_from_macos "libxml2"

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
