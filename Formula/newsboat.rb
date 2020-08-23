class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.20.1/newsboat-2.20.1.tar.xz"
  sha256 "82782079b75fe307f7a5a17dff9e712aa5975678fa550fb728d5a46867943566"
  license "MIT"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "185195a5551a37bebb3978986b9820557e71d6f7472dc47ac23cd73689a7c3ac" => :catalina
    sha256 "0bea20044257f4fd9128cfbed1c7d6d4c7d702128153c9f5203d4770b501e5ad" => :mojave
    sha256 "7bc4d0c9214a3b858848c11f0b11fd3a1fa2229ad5576ab134555afb1945b031" => :high_sierra
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
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
