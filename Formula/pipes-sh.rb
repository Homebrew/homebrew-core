class PipesSh < Formula
  desc "Animated pipes terminal screensaver"
  homepage "https://github.com/pipeseroni/pipes.sh"
  url "https://github.com/pipeseroni/pipes.sh/archive/v1.3.0.tar.gz"
  sha256 "532976dd8dc2d98330c45a8bcb6d7dc19e0b0e30bba8872dcce352361655a426"
  license "MIT"
  head "https://github.com/pipeseroni/pipes.sh.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "621d840685499f44efee09cf9e3fadf6912b971a6be35bc963741df01f440394"
    sha256 cellar: :any_skip_relocation, big_sur:       "777bd274db0376138c72b6d89948ad3b19b622f069477a74cbc8b0ad9e320d72"
    sha256 cellar: :any_skip_relocation, catalina:      "68d379998c00ca3662db8047c1c6e649491d65d851af264e04ce7cbdb7cbd2e2"
    sha256 cellar: :any_skip_relocation, mojave:        "b78492e9f13a815dc97200b33c4e228292a4679eb6d048c1094c64aa46504879"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2793ad5fb825b4f805a4731c7028cbcb2ca5e9dd904133df0cce7481c5961322"
    sha256 cellar: :any_skip_relocation, sierra:        "2793ad5fb825b4f805a4731c7028cbcb2ca5e9dd904133df0cce7481c5961322"
    sha256 cellar: :any_skip_relocation, el_capitan:    "2793ad5fb825b4f805a4731c7028cbcb2ca5e9dd904133df0cce7481c5961322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf4d651648f9ae9a9a26e64bfb729521d2448415ee8ebf633517eede0ba61849"
    sha256 cellar: :any_skip_relocation, all:           "da14dd754188372ac28504c4bf326749df47323c5179e96912ec1e0dd9fa6ad1"
  end

  depends_on "bash"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/pipes.sh -v").strip.split[-1]
  end
end
