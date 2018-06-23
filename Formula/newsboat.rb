class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://github.com/newsboat/newsboat/archive/r2.11.1.tar.gz"
  sha256 "0c48ec60e1abafd7b62cf8e376eff9e92dcb7bbc6e7dfed9b9ac141853d826d8"
  revision 1
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "40dab21789f3295916382b2c89565308d8c64849e338e3b5ec024eff522fc7b1" => :high_sierra
    sha256 "6f542c9b385968f538dcd67d67b9d09462d6b1dee4eefb080ce1ab24f70609e6" => :sierra
    sha256 "c40047c23d18ee45586a3820d67cb4c443605f40cbb88c6013d11c2def98b5ec" => :el_capitan
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
