class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.15/newsboat-2.15.tar.xz"
  sha256 "da68ce93c02dda908a471ef8994bb3c668f060eb6046d486c3f05649c6650db7"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "161f5c8a8ca0f1ca2aec9d398ebcfc4d562fe504143ad43ed35ac1421365e9e3" => :mojave
    sha256 "e0983452e560d48f483aa86925d6b499d21f9e2d23e6e8de83d0b8850fd16d99" => :high_sierra
    sha256 "8b0d477d4b320cc60ae820808bb7a134a04e3731632ebcacb0bf8b5fcad06246" => :sierra
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
