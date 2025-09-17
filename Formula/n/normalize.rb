class Normalize < Formula
  desc "Adjust volume of audio files to a standard level"
  homepage "https://www.nongnu.org/normalize/"
  url "https://savannah.nongnu.org/download/normalize/normalize-0.7.7.tar.gz"
  sha256 "6055a2abccc64296e1c38f9652f2056d3a3c096538e164b8b9526e10b486b3d8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/normalize/"
    regex(/href=.*?normalize[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:    "f0163055e113a859911c0c03c9fda88323d0895ba8b37c6347456dd174f5ce7b"
    sha256 cellar: :any, arm64_sequoia:  "53b16243f5e01a1b903a687774320986f9a27f92efd6af821aef4e3d7f354467"
    sha256 cellar: :any, arm64_sonoma:   "d85f441176672bd7b8a65f4b7e3469e742a32e044e38a8cfde3d4277579c6878"
    sha256 cellar: :any, arm64_ventura:  "f579a1e316959c958663d8cff690f2ad7d06da059e0234478ef19d4f67561b14"
    sha256 cellar: :any, arm64_monterey: "bd34a009747e235d7049f560d836ca8be0a722807b8f2b936e24c6d4618890af"
    sha256 cellar: :any, arm64_big_sur:  "31e0c2d4f6dd0aaae6830e87242bfc8c71077b04c94a41b4079d36e45eedc4ab"
    sha256 cellar: :any, sonoma:         "8c89f97455db64e450b7360d56b0c634f91d10b01a0234ba6e008eebd47baa4d"
    sha256 cellar: :any, ventura:        "cade314811b32193662502121c6004253e965fade1dce8d30c488c86872e1a9a"
    sha256 cellar: :any, monterey:       "4b27d07f9a6b9455c555682b9c43443bee7f70fb40d44a2f50dba54100164e18"
    sha256 cellar: :any, big_sur:        "a35a01c8d74067d94fda21d31a0ab65128842e6dc1ed0629ed6cadf99f13a9b5"
    sha256 cellar: :any, catalina:       "363ac4a56ccb75ff32f3af3ef42a6cf5d74f24b977939bb08c14fddc30ff2ef5"
    sha256               arm64_linux:    "a035755b426126bd056c7287f416cc068b3d399a100e56f8192178a6530048dc"
    sha256               x86_64_linux:   "ac6f58e169897ddfc61943009dd38044958a8fc56a025e91632d2302de3063df"
  end

  depends_on "mad"

  conflicts_with "num-utils", because: "both install `normalize` binaries"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--mandir=#{man}", *args, *std_configure_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system bin/"normalize", "test.mp3"
  end
end
