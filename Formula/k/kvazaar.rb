class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v2.2.0.tar.gz"
  sha256 "df21f327318d530fe7f2ec65ccabf400690791ebad726d8b785c243506f0e446"
  license "BSD-3-Clause"
  head "https://github.com/ultravideo/kvazaar.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9544f121fcf80c86e7a533fc46d0afb35f42f370df75c70a9511c3726cf19347"
    sha256 cellar: :any,                 arm64_ventura:  "6288e9f30c0867d86ffcba038ba1c28437f62003db8d5f8bdcee40d83ae488f9"
    sha256 cellar: :any,                 arm64_monterey: "6b453a1d960fbf141450aa01aaa058a3c2a3db6a5470d23c77513a17440d2dee"
    sha256 cellar: :any,                 arm64_big_sur:  "883a4ba0ebc324a24d09a5b4dde7b643db11c1c9b02cb863559a577a5c92cf68"
    sha256 cellar: :any,                 sonoma:         "970979ed0976428315f2d6cf6bff4cd110bc1bda0646b63586aa0e92c99fb493"
    sha256 cellar: :any,                 ventura:        "ac3156de70bbf7c64ee56e71fa7d908541777c486dd82ae1925db3d909045b7c"
    sha256 cellar: :any,                 monterey:       "53bf2185136c24b742340106e00e713787ccbf629edc097eed8338d375158f4d"
    sha256 cellar: :any,                 big_sur:        "4f87b89cef8bade7db47f16c829e0b3134cdc8af93082019c10381e68ca6ae01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "540ef6a3cbff85da484257e9044a1ece0c698905afd9835fe8896296b60b0be7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "yasm" => :build

  resource "homebrew-videosample" do
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
    resource("homebrew-videosample").stage do
      system bin/"kvazaar", "-i", "lm20.avi", "--input-res", "16x16", "-o", "lm20.hevc"
      assert_predicate Pathname.pwd/"lm20.hevc", :exist?
    end
  end
end
