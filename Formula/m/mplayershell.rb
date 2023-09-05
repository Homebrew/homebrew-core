class Mplayershell < Formula
  desc "Improved visual experience for MPlayer on macOS"
  homepage "https://github.com/donmelton/MPlayerShell"
  url "https://github.com/donmelton/MPlayerShell/archive/0.9.3.tar.gz"
  sha256 "a1751207de9d79d7f6caa563a3ccbf9ea9b3c15a42478ff24f5d1e9ff7d7226a"
  license "MIT"
  head "https://github.com/donmelton/MPlayerShell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bead3e2b5b52cc95ff824b0ff5fce66e0abade2cb0b6dc423ff95234e0f3d607"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3003edef26c3863115869954941cff51ef7976b31ddef7130ea8931073011fbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab5dcc40124f4b2e1e3971050548e96bf3e652fbd4c682a701c0d3549ced4c21"
    sha256 cellar: :any_skip_relocation, ventura:        "1b398dced75a1b8abc9297730a1e0aacd0bce8bc31b80317222489c78270d99e"
    sha256 cellar: :any_skip_relocation, monterey:       "394a7fd5b3beef51cc57058e2210cccfd9fda7ae045fba2551c1e62149bae6df"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d08f027c84780edc46b13b1e45a8255de0ec6a35798a1ea5230ef8cb4396e13"
    sha256 cellar: :any_skip_relocation, catalina:       "09cfdf5d08af35a3be96623c6535fece3acfbc60cf81247b118778cb2b68acc3"
    sha256 cellar: :any_skip_relocation, mojave:         "1be2bb2a8eccce7fa190b85af6e67fb7fe36393c32a8295852af0e6e390b6ee9"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c0b558e0508d80fe05a1d9617b7aa1986066c54bc0a3da585631eb406da5eb93"
    sha256 cellar: :any_skip_relocation, sierra:         "e9377eaebb65903037105bf3ed6ee301a182452791e9daeaadd08ccb732d9d1b"
    sha256 cellar: :any_skip_relocation, el_capitan:     "ae4c1c9d069053afa7e71867256b577e23bd0dec87a90ccab2ebeab089a3634b"
  end

  depends_on xcode: :build
  depends_on :macos
  depends_on "mplayer"

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "MPlayerShell.xcodeproj",
               "-target", "mps",
               "-configuration", "Release",
               "clean", "build",
               "SYMROOT=build",
               "DSTROOT=build"
    bin.install "build/Release/mps"
    man1.install "Source/mps.1"
  end

  test do
    system "#{bin}/mps"
  end
end
