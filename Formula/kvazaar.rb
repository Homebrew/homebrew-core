class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/releases/download/v1.2.0/kvazaar-1.2.0.tar.xz"
  sha256 "9bc9ba4d825b497705bd6d84817933efbee43cbad0ffaac17d4b464e11e73a37"

  bottle do
    cellar :any
    sha256 "e87324de6181bf05d7da589711e4b1980302b92153980af5a7ae083e7a2cbd16" => :high_sierra
    sha256 "4f7c9e10e8725fb90eaa7f49fe5dfdc6e746d346294328d6a6f9d0b4b44aebdc" => :sierra
    sha256 "f6389f0c17f8383a575d38db1ef54337909a9654136b68016f6b14853872f03a" => :el_capitan
    sha256 "cbc275e60845c45f968dce9e00d11124830f5a72966c6814b42f8fffaa821df0" => :yosemite
  end

  head do
    url "https://github.com/ultravideo/kvazaar.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "yasm" => :build

  resource "videosample" do
    url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # download small sample and try to encode it
    resource("videosample").stage do
      system bin/"kvazaar", "-i", "lm20.avi", "--input-res", "16x16", "-o", "lm20.hevc"
      assert_predicate Pathname.pwd/"lm20.hevc", :exist?
    end
  end
end
