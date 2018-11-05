class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://github.com/newsboat/newsboat/archive/r2.13.tar.gz"
  sha256 "3e3b30a03dda293b6187475ae300abe9fcdbf03b98e55ed8f1fe6a0ffa548508"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "39591292ef2d14766054c2377bab5cfae414240ca8dcabdae316110c8d708ac2" => :mojave
    sha256 "df24a26f67d6b93bb05d1f01184623f32eff704c11e56554cdb1e91551a75a6a" => :high_sierra
    sha256 "a480f72dfacdb14af039b62119a56d13d32b082af92627e578483fc3d74ba475" => :sierra
    sha256 "91b6ac581d633502278dcea2dbdbcf01c6fd9d164b04639e0b9354d5db8dc3a2" => :el_capitan
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
