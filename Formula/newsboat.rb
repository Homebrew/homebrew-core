class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.15/newsboat-2.15.tar.xz"
  sha256 "da68ce93c02dda908a471ef8994bb3c668f060eb6046d486c3f05649c6650db7"
  revision 1
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "887ea19daea887297f99ddc451b5ecb6cfcd75e9135e41b055e98b1e0f63b39d" => :mojave
    sha256 "5bb58612f98daaade99b4f0df9118fb8a4a193a64597a173c0c1459843030274" => :high_sierra
    sha256 "9f2f19ec0cac38013807fe705b6476a319fdeacefc150c2edff37ed97cfca1f1" => :sierra
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
