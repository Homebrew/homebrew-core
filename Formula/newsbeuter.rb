class Newsbeuter < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsbeuter.org/"
  revision 2
  head "https://github.com/akrennmair/newsbeuter.git"

  stable do
    url "https://www.newsbeuter.org/downloads/newsbeuter-2.9.tar.gz"
    sha256 "74a8bf019b09c3b270ba95adc29f2bbe48ea1f55cc0634276b21fcce1f043dc8"

    # Remove for > 2.9; fix CVE-2017-12904
    # Upstream commit from 13 Aug 2017 "Sanitize inputs to bookmark-cmd (#591)"
    # See https://github.com/akrennmair/newsbeuter/commit/96e9506ae9e252c548665152d1b8968297128307
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/9e85ce0c072/net/newsbeuter/files/patch-CVE-2017-12904.diff"
      sha256 "09023b3d1e2166e7a72f5a9e1fe5e4b8ca24329e23b74abe8e80bac8e5211848"
    end
  end

  bottle do
    cellar :any
    sha256 "a87ab5abfae285c0987372d5d0b91b4f019ad291a544437b4d50b7eb7885af1b" => :sierra
    sha256 "62083ee807381d0cf55f6b7e7a43cd5cd6bf0090f2188113dbfc2ffc80beedaf" => :el_capitan
    sha256 "2283a19b46488e99a8fbd7ce527ac61723aff70f31407e369243a8609dadca7e" => :yosemite
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
