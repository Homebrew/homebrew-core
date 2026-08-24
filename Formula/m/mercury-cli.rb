class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.11.8.tar.gz"
  sha256 "954c4e088ea7d714abd215efeafc2161218bc5e5952ab8de30ae8701befcf801"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a796ec164885030d8dbaebd2ece71ec9339c9f45d2b60dfcb4d0089ac113a0d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a796ec164885030d8dbaebd2ece71ec9339c9f45d2b60dfcb4d0089ac113a0d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a796ec164885030d8dbaebd2ece71ec9339c9f45d2b60dfcb4d0089ac113a0d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "999b03b6f69adf280a19a6e6901464759df17ed0f55659fdfcad317766abab5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9528a0e94169eea9c1096ac2fb3d3ab894683c96fe9302a9ef04687e990d654"
    sha256 cellar: :any,                 x86_64_linux:  "42500e43d3efcd32b33c0e127205e1087c4e3242991cc95ac79bc02455c4e1ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end
