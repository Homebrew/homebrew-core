class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.19/newsboat-2.19.tar.xz"
  sha256 "ba484c825bb903daf6d33d55126107b59e41111b455d368362208f1825403d1b"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "9b650d0f032cd046cc75de2870186977666892ddef0c120e9481d452aed64679" => :catalina
    sha256 "59c06c5a6b1e7c360f9c31c93e7d2f25296ce8a0048b47ad365cb642c2365d19" => :mojave
    sha256 "023a4bcb967d4bd7bd052a59167b1581d16e261c1dbe2a0fdac11d8b38ee816d" => :high_sierra
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
