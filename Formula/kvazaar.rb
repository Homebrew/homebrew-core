class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v2.0.0.tar.gz"
  sha256 "213edca448f127f9c6d194cdfd21593d10331f9061d95751424e1001bae60b5d"
  license "LGPL-2.1"
  head "https://github.com/ultravideo/kvazaar.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "68cbd47ca58bca7528f9e9a86cd3f6fed66481432f57731f6bc0c8e3e10f25b9"
    sha256 cellar: :any,                 big_sur:       "294a8c34175f2338af524ca7b7cf134d9893405013314c006ad3e075160e28b6"
    sha256 cellar: :any,                 catalina:      "75467ab21cc9bb1a3f81f41949a0312300f9d470b4547e827111379b94a237d8"
    sha256 cellar: :any,                 mojave:        "d146e6aa5dda30a3353f72bae18356622fe613e1a7a43ae6d5d5e2fa8bfc2aba"
    sha256 cellar: :any,                 high_sierra:   "50723e7fbe1dfb25f2ba39b84f4059b208bed481ae0832d00f24c7221bdde905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "708fb79e330e9bed6ae833277613676d5600145b2eb39acfba985e7ce881cd22"
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
