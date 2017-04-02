class Newsbeuter < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsbeuter.org/"
  url "https://www.newsbeuter.org/downloads/newsbeuter-2.9.tar.gz"
  sha256 "74a8bf019b09c3b270ba95adc29f2bbe48ea1f55cc0634276b21fcce1f043dc8"
  revision 1

  head "https://github.com/akrennmair/newsbeuter.git"

  bottle do
    cellar :any
    sha256 "7aa6c0a8f1d652bcf7bcc6f6109264c3101fdd3aba6b43891f449fe69284b7cc" => :sierra
    sha256 "b6c4ce2cfab8856fed986a64dd4272c0838eabaaacb0d95d097dddb7340b59a1" => :el_capitan
    sha256 "76149f52b3abd4676f7a754d173d61142235ac54ad4c91a66c52bd5ea644ba5e" => :yosemite
    sha256 "420fc7693d89145d70b6b4d435e53d958263f0b210bd83c83af3832c322f3e8b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"
  depends_on "sqlite"

  needs :cxx11

  def install
    ENV.cxx11
    system "make"
    system "make", "install", "prefix=#{prefix}"

    share.install "contrib"
    (doc/"examples").install "doc/example-bookmark-plugin.sh"
  end

  test do
    urlfile = "urls.txt"
    (testpath/urlfile).write "https://github.com/blog/subscribe\n"
    assert_match /newsbeuter - Exported Feeds/m, shell_output("#{bin}/newsbeuter -e -u #{urlfile}")
  end
end
