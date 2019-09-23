class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.17/newsboat-2.17.tar.xz"
  sha256 "88c3f73b676f5fc52a0c935922eb520b463b388c7ef2325e67d847bee41efa79"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "0ffa77388011a97cb696ec2e264702faeef9ddb07522109282930dd7681c7395" => :mojave
    sha256 "75550ca76884dcbf7a75e60b53ba5470ab4e4d690fead6772fbe7bf5a8b36991" => :high_sierra
    sha256 "249281b2b4228e69893c09f0a8f503ae59f3819bff5e7fc6c12d3045586141be" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"
  uses_from_macos "libxml2"

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
