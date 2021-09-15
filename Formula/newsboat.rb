class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.24/newsboat-2.24.tar.xz"
  sha256 "62420688cca25618859548d10ff6df9ac75b9cf766699f37edd3e324d67c6ffb"
  license "MIT"
  revision 1
  head "https://github.com/newsboat/newsboat.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "56dfe1b2c6f47820764638c40cd9551b3c251a07baba3834479ae2fde9cbfd53"
    sha256 big_sur:       "dd32e75e07680644d5cef9736e77366f3373b69f5dfa471fc1890df98988862b"
    sha256 catalina:      "409cf4cb21d90f201508b289336782010a51bcaf024e4a127b3163c12fc392dd"
    sha256 mojave:        "c90b373c50ff225cd8e78a68fdf966227b9ac29b980974f239095071a1040548"
    sha256 x86_64_linux:  "f990df0f3f7abca0a2a440940593f0f6935c72d98a356a52a2217a05ec58388a"
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
