class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.92",
      revision: "1a7652cfc27cd92357b24e5cc41d96ab6c97fdf7"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5bb96cf07814df4f62cacf2a8c4de1d68e0cd076ece2d86f4348b51865c8ffe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5bb96cf07814df4f62cacf2a8c4de1d68e0cd076ece2d86f4348b51865c8ffe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5bb96cf07814df4f62cacf2a8c4de1d68e0cd076ece2d86f4348b51865c8ffe"
    sha256 cellar: :any_skip_relocation, ventura:        "a1add9d02ff3f63d3c737fbd95fde971df732500d0aaf0036e1c9b915825a2f0"
    sha256 cellar: :any_skip_relocation, monterey:       "a1add9d02ff3f63d3c737fbd95fde971df732500d0aaf0036e1c9b915825a2f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1add9d02ff3f63d3c737fbd95fde971df732500d0aaf0036e1c9b915825a2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1756e2e30b5c8684d44932752cc4a42a9715477f1255bab4a729c313e2ccf464"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
