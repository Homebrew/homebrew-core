class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.17.1/newsboat-2.17.1.tar.xz"
  sha256 "c1ebd24b017173156e817a1a3dd1d982808dec30a891e1f487806e5f86171997"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "f6451106698ac808b6f22ed7ab6bb4d019b30079e7944167285eddf3ecf0b916" => :catalina
    sha256 "2ded97dc9d4cbe6cdbe956042c398fa3b738d3144e171132a35df019d2b26701" => :mojave
    sha256 "cde234e22ebd42f8a6b465ca2da903401104d4288f2dd0cc71b11c67e6367f4f" => :high_sierra
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
