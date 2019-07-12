class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v1.3.0.tar.gz"
  sha256 "f694fe71cc6e3e6f583a9faf380825ea93b2635c4db8d1d3121b9ebcf736ac1c"
  head "https://github.com/ultravideo/kvazaar.git"

  bottle do
    cellar :any
    sha256 "cdd936796111dc2b579a313780538417a74e9f2a024deb7f516b255f49c3d377" => :mojave
    sha256 "81e3084935b40153b533da73526e453280ffb09fac29745d43d4e305b462aa9a" => :high_sierra
    sha256 "0f8150c11184a4a7af203db7e11b9942ceeabd8442e82ff2e34c53145cd85be3" => :sierra
    sha256 "918e7ad37489d7bc2c602b47678f85392bcaeca1805e01953e7dabe54c1a153b" => :el_capitan
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
      assert_predicate Pathname.pwd/"lm20.hevc", :exist?
    end
  end
end
