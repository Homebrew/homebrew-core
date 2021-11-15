class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v2.1.0.tar.gz"
  sha256 "bbdd3112182e5660a1c339e30677f871b6eac1e5b4ff1292ee1ae38ecbe11029"
  license "BSD-3-Clause"
  head "https://github.com/ultravideo/kvazaar.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d84d0ad2462ff6c0fbe5ea7d2530c17d8d22629081fde5756fec48cd8ac5c409"
    sha256 cellar: :any,                 arm64_big_sur:  "c2f8e51a5222f0b4f114df45c9a6439b84134c282a4147a3a8f5bd57aa297f14"
    sha256 cellar: :any,                 monterey:       "2e8db48a773c5754ec93786ae52d7bb09c94cb40fa811d0b12457540fcc378c5"
    sha256 cellar: :any,                 big_sur:        "68ec96b70d3098071e315f09d9b68d69971dd362d586e69f1c3d6938edc760f5"
    sha256 cellar: :any,                 catalina:       "09205d5d2e16355e031d467315842030923f4459fed71576889f372f895f3b98"
    sha256 cellar: :any,                 mojave:         "420616c74f44f1f604a2e4533d91bca6a4e014ae742d887200d927e007ae4fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d28aa580e27dade3635f38fa914f2975718e4e7ea2d89b7b1d46569efa6612b3"
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
