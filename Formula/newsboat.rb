class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.16.1/newsboat-2.16.1.tar.xz"
  sha256 "4023c817b36fc08a3191283eec2c7161949c0727633f60ad837e11c599d3ad53"
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
