class Mplayershell < Formula
  desc "Improved visual experience for MPlayer on macOS"
  homepage "https://github.com/lisamelton/MPlayerShell"
  url "https://github.com/lisamelton/MPlayerShell/archive/refs/tags/0.9.3.tar.gz"
  sha256 "a1751207de9d79d7f6caa563a3ccbf9ea9b3c15a42478ff24f5d1e9ff7d7226a"
  license "MIT"
  head "https://github.com/lisamelton/MPlayerShell.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "60d548374e75eccb8dfb8ebb31df066dbb482f8bbd0ec5bf273c62392d323de6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b95550c4987ef7c396da3dccfdd64e309be1d1945fec7f520215c674615174c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e13d71055ed301f6cb2ce85ad882a79d6d9bb89768a65d343924683fec3eedc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bead3e2b5b52cc95ff824b0ff5fce66e0abade2cb0b6dc423ff95234e0f3d607"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3003edef26c3863115869954941cff51ef7976b31ddef7130ea8931073011fbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab5dcc40124f4b2e1e3971050548e96bf3e652fbd4c682a701c0d3549ced4c21"
    sha256 cellar: :any_skip_relocation, sonoma:         "d658c84ae0c3d0138efff810c4734ac93be2050d16c77a92ef0951acdc01db48"
    sha256 cellar: :any_skip_relocation, ventura:        "1b398dced75a1b8abc9297730a1e0aacd0bce8bc31b80317222489c78270d99e"
    sha256 cellar: :any_skip_relocation, monterey:       "394a7fd5b3beef51cc57058e2210cccfd9fda7ae045fba2551c1e62149bae6df"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d08f027c84780edc46b13b1e45a8255de0ec6a35798a1ea5230ef8cb4396e13"
    sha256 cellar: :any_skip_relocation, catalina:       "09cfdf5d08af35a3be96623c6535fece3acfbc60cf81247b118778cb2b68acc3"
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
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
               "DSTROOT=build"
    bin.install "build/Release/mps"
    man1.install "Source/mps.1"
  end

  test do
    system bin/"mps"
  end
end
