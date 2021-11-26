class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.25/newsboat-2.25.tar.xz"
  sha256 "41aaab378f1dc9eff5094fc4a686a602c76497cb6c4b656c65e843a71fa6017e"
  license "MIT"
  head "https://github.com/newsboat/newsboat.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "a421778c2fd02d013e3fba6727a392f3ab6c70a32aad94dca38274f8c0a15102"
    sha256 big_sur:       "96697aefcedc5c791b07e1734d8cd6f74eb2842e5dd51283c0b9757b64e62747"
    sha256 catalina:      "e259be3ed054eab870bcbc69ac9bcb008dcb9cdd8934d57ccef924db735c66a3"
    sha256 mojave:        "f92958ea54f0a648755c5b5df384bf1bf88280dfeac15a4a06aa122e19af087b"
    sha256 x86_64_linux:  "a8e76829cb365ae43de0e3aa6d442c1a95378abb59a19f6a2f006f0910e3d44b"
  end

  deprecate! date: "2021-11-26", because: "libstfl is deprecated"

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
