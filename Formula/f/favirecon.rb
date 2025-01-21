class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://github.com/edoardottt/favirecon"
  url "https://github.com/edoardottt/favirecon/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "ab11b19ac7f78e41cd00df5832f4ead73a33a2e8e9a3f9c9099f596d3fe11405"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40f67c348cd32b50b8d6f27c933ff620153503030a5cc12eb38b50fa242de30e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40f67c348cd32b50b8d6f27c933ff620153503030a5cc12eb38b50fa242de30e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40f67c348cd32b50b8d6f27c933ff620153503030a5cc12eb38b50fa242de30e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bc2f04831805761b2c04c30507f59c0b7622334cadfaeacba1d6a5f7de6ec0e"
    sha256 cellar: :any_skip_relocation, ventura:       "8bc2f04831805761b2c04c30507f59c0b7622334cadfaeacba1d6a5f7de6ec0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53e98be9e8cb6265734b57e242db0966079d444498adf9d4387ac6bb3d83d8ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/favirecon"
  end

  test do
    output = shell_output("#{bin}/favirecon -u https://www.github.com")
    assert_match "[GitHub] https://www.github.com/favicon.ico", output
  end
end
