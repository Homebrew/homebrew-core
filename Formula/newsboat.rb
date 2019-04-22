class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.15/newsboat-2.15.tar.xz"
  sha256 "da68ce93c02dda908a471ef8994bb3c668f060eb6046d486c3f05649c6650db7"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "e8708822b4a63c505f53d3a8cb9fbe2749516d1a405dd6249c33a814c37e8307" => :mojave
    sha256 "8c96b6420377d33205cc21a064b9057511f9c89dfdde1e6a23066d9ecc25049c" => :high_sierra
    sha256 "7a5c0c97fbea332c2b62f7bf2783591f932a583661d7b0b8ac4c762a21cb546d" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
