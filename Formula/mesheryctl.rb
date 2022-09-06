class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.6",
      revision: "9b0c8ec6c9d0367ebe8c6b0ebad14447f5eb9fe3"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f46d7949294e71c058f449c586c5e1f5ac4efc19ba6a7677f816d18ade5825b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f46d7949294e71c058f449c586c5e1f5ac4efc19ba6a7677f816d18ade5825b"
    sha256 cellar: :any_skip_relocation, monterey:       "de83b47ea78acdf525d1edbb463ccb99d9c9ceb85029a8429798de1512d8f82b"
    sha256 cellar: :any_skip_relocation, big_sur:        "de83b47ea78acdf525d1edbb463ccb99d9c9ceb85029a8429798de1512d8f82b"
    sha256 cellar: :any_skip_relocation, catalina:       "de83b47ea78acdf525d1edbb463ccb99d9c9ceb85029a8429798de1512d8f82b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04af1fa4e41db65a33a79f3601873b10ebcfb7dea2403e17f4446ed21d577bba"
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
