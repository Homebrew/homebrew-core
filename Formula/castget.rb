class Castget < Formula
  desc "Command-line podcast and RSS enclosure downloader"
  homepage "https://castget.johndal.com/"
  url "https://download.savannah.gnu.org/releases/castget/castget-2.0.1.tar.bz2"
  sha256 "438b5f7ec7e31a45ed3756630fe447f42015acda53ec09202f48628726b5e875"
  license "LGPL-2.1-only"

  livecheck do
    url "https://download.savannah.gnu.org/releases/castget/"
    regex(/href=.*?castget[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "dab2c9c9952ce1ecd3263ed1d6c1c002c772c9e7c310bde0b6277c46fd424edf"
    sha256 cellar: :any, arm64_big_sur:  "320ee21622d1bd939ea95055395d84e5d7cb2d6f091d0da9f05c9eb3d0cff7b9"
    sha256 cellar: :any, monterey:       "e504eb4b4d6c38f21fdb20a8424de8ac6e98ee4dd970c397da89c0f936520be6"
    sha256 cellar: :any, big_sur:        "b91da84bac0b31dfb521f193b519c984cf943f15974f9427fa3e780028ea07aa"
    sha256 cellar: :any, catalina:       "83d589037e4418829134060be140fce4b4b9883b9b68376f20257df68d9fff9a"
    sha256 cellar: :any, mojave:         "fedc8c680b948b9f87cfd3f63f90bd6cb02143120a9c74d5b1bc5a04e84290d9"
    sha256 cellar: :any, high_sierra:    "4d1f21bb31abc39d28110a76608493423f96a1f19c4b67c1cb651887f3848675"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "id3lib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.rss").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <rss version="2.0">
        <channel>
          <title>Test podcast</title>
          <description>Test podcast</description>
          <link>http://www.podcast.test/</link>
          <item>
            <title>Test item</title>
            <enclosure url="#{test_fixtures("test.mp3")}" type="audio/mpeg" />
          </item>
        </channel>
      </rss>
    EOS

    (testpath/"castgetrc").write <<~EOS
      [test]
      url=file://#{testpath/"test.rss"}
      spool=#{testpath}
    EOS

    system "#{bin}/castget", "-C", testpath/"castgetrc"
    assert_predicate testpath/"test.mp3", :exist?
  end
end
