class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v2.0.0.tar.gz"
  sha256 "213edca448f127f9c6d194cdfd21593d10331f9061d95751424e1001bae60b5d"
  head "https://github.com/ultravideo/kvazaar.git"

  bottle do
    cellar :any
    sha256 "75467ab21cc9bb1a3f81f41949a0312300f9d470b4547e827111379b94a237d8" => :catalina
    sha256 "d146e6aa5dda30a3353f72bae18356622fe613e1a7a43ae6d5d5e2fa8bfc2aba" => :mojave
    sha256 "50723e7fbe1dfb25f2ba39b84f4059b208bed481ae0832d00f24c7221bdde905" => :high_sierra
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
