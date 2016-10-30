class Ezstream < Formula
  desc "Client for Icecast streaming servers"
  homepage "http://www.icecast.org/ezstream.php"
  url "http://downloads.xiph.org/releases/ezstream/ezstream-0.6.0.tar.gz"
  sha256 "f86eb8163b470c3acbc182b42406f08313f85187bd9017afb8b79b02f03635c9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "eee3cc2ed988d5c0e131d9ba8f0aef0e7bb520311096a9719b914c0a1ca6ffe4" => :sierra
    sha256 "365c26a87addf50359e65ccd98ce4244b61f7e9015a335ff47bf55a90b35ad19" => :el_capitan
    sha256 "dfa4b2537b1ce6b0da0c4214ccedca664bdd2e69962fa6579d9c437b1ff94e92" => :yosemite
    sha256 "04e3a89b8b1e91ce160ec94c981b71d8fb08d7be8fef3da3f1c33b29dc9e3f8c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "libshout"
  depends_on "theora"
  depends_on "speex"
  depends_on "libogg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.m3u").write test_fixtures("test.mp3").to_s
    system bin/"ezstream", "-s", testpath/"test.m3u"
  end
end
