class Castget < Formula
  desc "Command-line podcast and RSS enclosure downloader"
  homepage "https://castget.johndal.com/"
  url "https://savannah.nongnu.org/download/castget/castget-2.0.1.tar.bz2"
  sha256 "438b5f7ec7e31a45ed3756630fe447f42015acda53ec09202f48628726b5e875"
  license "LGPL-2.1-only"

  bottle do
    cellar :any
    sha256 "83d589037e4418829134060be140fce4b4b9883b9b68376f20257df68d9fff9a" => :catalina
    sha256 "fedc8c680b948b9f87cfd3f63f90bd6cb02143120a9c74d5b1bc5a04e84290d9" => :mojave
    sha256 "4d1f21bb31abc39d28110a76608493423f96a1f19c4b67c1cb651887f3848675" => :high_sierra
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
