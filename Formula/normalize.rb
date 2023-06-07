class Normalize < Formula
  desc "Adjust volume of audio files to a standard level"
  homepage "https://www.nongnu.org/normalize/"
  url "https://savannah.nongnu.org/download/normalize/normalize-0.7.7.tar.gz"
  sha256 "6055a2abccc64296e1c38f9652f2056d3a3c096538e164b8b9526e10b486b3d8"
  license "GPL-2.0"

  livecheck do
    url "https://download.savannah.gnu.org/releases/normalize/"
    regex(/href=.*?normalize[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "f579a1e316959c958663d8cff690f2ad7d06da059e0234478ef19d4f67561b14"
    sha256 cellar: :any, arm64_monterey: "bd34a009747e235d7049f560d836ca8be0a722807b8f2b936e24c6d4618890af"
    sha256 cellar: :any, arm64_big_sur:  "31e0c2d4f6dd0aaae6830e87242bfc8c71077b04c94a41b4079d36e45eedc4ab"
    sha256 cellar: :any, ventura:        "cade314811b32193662502121c6004253e965fade1dce8d30c488c86872e1a9a"
    sha256 cellar: :any, monterey:       "4b27d07f9a6b9455c555682b9c43443bee7f70fb40d44a2f50dba54100164e18"
    sha256 cellar: :any, big_sur:        "a35a01c8d74067d94fda21d31a0ab65128842e6dc1ed0629ed6cadf99f13a9b5"
    sha256 cellar: :any, catalina:       "363ac4a56ccb75ff32f3af3ef42a6cf5d74f24b977939bb08c14fddc30ff2ef5"
    sha256 cellar: :any, mojave:         "8e1ac6ecbf84164c27a804b158201b75ddaabd3237e5826d7ffc78fbe8ee7377"
    sha256 cellar: :any, high_sierra:    "e4dd195c639807e3e2e25fee6c5c6f3c4263a37a4c7f8f25ab656a96395faeaf"
    sha256 cellar: :any, sierra:         "1165de2721e8b4d7f373b9ad10f52c2cd49c44a24cd8fddab5ba51983164cefe"
    sha256 cellar: :any, el_capitan:     "052ab2e8b1f6a2aa1e634a30749612d927b5cee5cc9302e057bd02c599a1c256"
    sha256               x86_64_linux:   "ac6f58e169897ddfc61943009dd38044958a8fc56a025e91632d2302de3063df"
  end

  depends_on "mad"

  conflicts_with "num-utils", because: "both install `normalize` binaries"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system "#{bin}/normalize", "test.mp3"
  end
end
