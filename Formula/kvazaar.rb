class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v0.8.2.tar.gz"
  sha256 "1b9354a639ab6c902e974780b39112b5e75477205611f88b54562c895182b945"
  head "https://github.com/ultravideo/kvazaar.git"

  bottle do
    cellar :any
    sha256 "45a41530791f514842620ce53d6b03cf3915f396bf50b2fdc7025fd1917fadb4" => :sierra
    sha256 "51cc24538d1978ad0dc4d52056e45a3fcf2960d6d859ec728c4edd44e267dfde" => :el_capitan
    sha256 "165654dedd6d7bb438ea9215789bf97a8fa426b3e7f09b1f010559c680a6b7b6" => :yosemite
    sha256 "ae000ea2d5cb4717dce904aa371813e3603c0b05bf333306948457848e22c272" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "yasm" => :build

  resource "videosample" do
    url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # download small sample and try to encode it
    resource("videosample").stage do
      system bin/"kvazaar", "-i", "lm20.avi", "--input-res", "16x16", "-o", "lm20.hevc"
      assert File.exist? "lm20.hevc"
    end
  end
end
