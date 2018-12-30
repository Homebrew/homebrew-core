class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://github.com/newsboat/newsboat/archive/r2.14.tar.gz"
  sha256 "57176071b0c777ddba237f95f684e36bf2ddf271e84ac5c9e3eec8f1afc0b133"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "dfede6575e701116cc059743f58c014ad6adcb6995dbd2cec194b6ae1ef8fee6" => :mojave
    sha256 "d83a1212683139dd4c5858f8236b71e70ba38724b8f20abb5b1025e1c0e94c82" => :high_sierra
    sha256 "60cea17e5dd6e8578196aa34266f058521f5f72b279e2ba6c93b1cdcad035baa" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
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
