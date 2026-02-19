class Castget < Formula
  desc "Command-line podcast and RSS enclosure downloader"
  homepage "https://castget.johndal.com/"
  url "https://download.savannah.gnu.org/releases/castget/castget-2.0.1.tar.bz2"
  sha256 "438b5f7ec7e31a45ed3756630fe447f42015acda53ec09202f48628726b5e875"
  license "LGPL-2.1-only"
  revision 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/castget/"
    regex(/href=.*?castget[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6260cc2436ada19971dceea5edf959d05602b072b8c9e4fe4e3cd4ba2d1cd414"
    sha256 cellar: :any,                 arm64_sequoia: "0a168ca1b2f72f15dec7ccc87492f7687daa913751dc92f93e170847d725d415"
    sha256 cellar: :any,                 arm64_sonoma:  "ee0922a3c5490cca1a84c0d904fdfc85c009e1a78ec97bde96160268d70aa313"
    sha256 cellar: :any,                 sonoma:        "3646b6392004a2f98d56791883ba1ca786ec99adae13d51ca03f92ad5e7b60d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84883011e5ed23dc9d2fa31362f00893d18f6f8071c736b60e5068a0ed9785ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ad8497c3d8ea308f9e37f9da0fed84e68dc1194d44e9a5f27c89b2b37d0ce44"
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
