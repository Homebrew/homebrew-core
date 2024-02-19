class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "6d88a9c92c06c275e33ff5df9ed6081f43277988b782298544caa76c20b2b601"
  license "BSD-3-Clause"
  head "https://github.com/ultravideo/kvazaar.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "07ef15a99eff93bfb2480c95ddf9bf88009894f49499219dd2312601ce8f9b35"
    sha256 cellar: :any,                 arm64_ventura:  "aa19c913680dddaf84d46b03dbb9e1931d0ceb3c3a351deceff0dc323abe210a"
    sha256 cellar: :any,                 arm64_monterey: "13cfd7cab68789ee888068796850f722021d35b0180f1816fa2252da86808b2b"
    sha256 cellar: :any,                 sonoma:         "79523ac3488c084935a4885dca197a104107f77c16084c5ece2b6dbda49b0548"
    sha256 cellar: :any,                 ventura:        "44a38c7a4204b4a520a96c6d98f184b382dd5cf52bb22025bb4c1fba4506a1d1"
    sha256 cellar: :any,                 monterey:       "ad362f1a9e7e7f9bd5162fe50fcb1a9598be648f243e477bdbdeb7b0a4a7c52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81f432151f29ee23c36bf07c5e2c4f18b1e94a4b75bd1438d24bffa660cdd275"
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
