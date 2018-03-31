class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://github.com/newsboat/newsboat/archive/r2.11.1.tar.gz"
  sha256 "0c48ec60e1abafd7b62cf8e376eff9e92dcb7bbc6e7dfed9b9ac141853d826d8"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "51c649e723be67ea3411355715feffe37e17178b283b8144db74b9c6bda79681" => :high_sierra
    sha256 "d0ea108ad513295986adbea37fd1d0248918b6ec85a8f772ddb73dc81f5aebd2" => :sierra
    sha256 "a51343a86711ad1cc4657ce9d12964125bc0b42ee0b7c33cff2539413239f634" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  needs :cxx11

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
