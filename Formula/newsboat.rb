class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.21/newsboat-2.21.tar.xz"
  sha256 "0c46b3dd46bb578dd6dd4915db4cfdffb4352ab258f251080ad14655c75a9c31"
  license "MIT"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "92ca6145a67fd736775f6a0febd2518791e219bc253f38c6be4a4ee9f3ce3a17" => :catalina
    sha256 "e8f3da04166c035bda743a3e4170fe58f33b83f00d983a2c56f8d2877b0f4fc7" => :mojave
    sha256 "795abbec7c52ed5adf77b8faf4bd56a26ac7bfba490fd6d1581d1a13c54cea98" => :high_sierra
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
