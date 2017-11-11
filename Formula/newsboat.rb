class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://github.com/newsboat/newsboat/archive/r2.10.1.tar.gz"
  sha256 "82d5e3e2a6dab845aac0bf72580f46c2756375d49214905a627284e5bc32e327"
  head "https://github.com/newsboat/newsboat.git"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  needs :cxx11

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
