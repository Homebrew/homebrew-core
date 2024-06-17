class Msieve < Formula
  desc "C library for factoring large integers"
  homepage "https://sourceforge.net/projects/msieve/"
  url "https://downloads.sourceforge.net/project/msieve/msieve/Msieve%20v1.53/msieve153_src.tar.gz"
  sha256 "c5fcbaaff266a43aa8bca55239d5b087d3e3f138d1a95d75b776c04ce4d93bb4"
  license :public_domain

  livecheck do
    url :stable
    regex(%r{url=.*?/Msieve%20v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e2048a031203ed1bb7bb3ee4becb928faa9f6d40b96ce62d3718873dd25bc83e"
    sha256 cellar: :any,                 arm64_ventura:  "b5fd08185a6cccac73b0cbdbc912880cababcee826bf5dbd3a07a6b6a590b53d"
    sha256 cellar: :any,                 arm64_monterey: "58f7c8472236d7c6213d11a6160e9b58a07de88dd07f0cb2c6281d3d800ce942"
    sha256 cellar: :any,                 sonoma:         "0be196c24813acf765158fe9fc3c525daf39627c52b762e6dcb54e99dad4fd6f"
    sha256 cellar: :any,                 ventura:        "712fbadc3fd1dca26ddb4c0d578c9d067e3c246c8fb56ef27eaa611ca5a60cea"
    sha256 cellar: :any,                 monterey:       "5d992af057d4b06b7f0898fbdd560410efeca4d336a4e562a916af392fe21019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8580e27cfae573df3fd975a42ceea4967f1397e566523189f385ce7a128148e"
  end

  depends_on "gmp"

  uses_from_macos "zlib"

  def install
    ENV.append "MACHINE_FLAGS", "-include sys/time.h"
    system "make", "all"
    bin.install "msieve"
  end

  test do
    assert_match "20\np1: 2\np1: 2\np1: 5", shell_output("#{bin}/msieve -q 20")
  end
end
