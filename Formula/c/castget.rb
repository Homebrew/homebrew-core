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
    sha256 cellar: :any,                 arm64_sequoia:  "4ef2a3166dbe4c983bc4a83b891b28b430ecb348e0043da7f0a512cdf7391444"
    sha256 cellar: :any,                 arm64_sonoma:   "a2f710b3cc40945afaef214606dc94e036ab266e176158fcd5dbd3e11b3de117"
    sha256 cellar: :any,                 arm64_ventura:  "85bc8985e90ece6ae58bf9d7a1f68eda1d2d2b3744694f5d7dfcfaf82d9b33df"
    sha256 cellar: :any,                 arm64_monterey: "dab2c9c9952ce1ecd3263ed1d6c1c002c772c9e7c310bde0b6277c46fd424edf"
    sha256 cellar: :any,                 arm64_big_sur:  "320ee21622d1bd939ea95055395d84e5d7cb2d6f091d0da9f05c9eb3d0cff7b9"
    sha256 cellar: :any,                 sonoma:         "429edbc96bddebb64265eb6450a5ef92b6205979ce49d643b02c37b5a6928551"
    sha256 cellar: :any,                 ventura:        "6fc622c18f0e57ca04747ce77b5663200f6669c6a1a4f01b071a13ae942ca231"
    sha256 cellar: :any,                 monterey:       "e504eb4b4d6c38f21fdb20a8424de8ac6e98ee4dd970c397da89c0f936520be6"
    sha256 cellar: :any,                 big_sur:        "b91da84bac0b31dfb521f193b519c984cf943f15974f9427fa3e780028ea07aa"
    sha256 cellar: :any,                 catalina:       "83d589037e4418829134060be140fce4b4b9883b9b68376f20257df68d9fff9a"
    sha256 cellar: :any,                 mojave:         "fedc8c680b948b9f87cfd3f63f90bd6cb02143120a9c74d5b1bc5a04e84290d9"
    sha256 cellar: :any,                 high_sierra:    "4d1f21bb31abc39d28110a76608493423f96a1f19c4b67c1cb651887f3848675"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "830e5a5c2cc130c2134ccfa526f99794cb737726f810c23d773cfe060d84faeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "590a6ec3e2fe983ff5c82e3b5b96b43c87f3a51fd7848216da86dc48ba01b8ca"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "id3lib"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.rss").write <<~XML
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
    XML

    (testpath/"castgetrc").write <<~EOS
      [test]
      url=file://#{testpath/"test.rss"}
      spool=#{testpath}
    EOS

    system bin/"castget", "-C", testpath/"castgetrc"
    assert_path_exists testpath/"test.mp3"
  end
end
