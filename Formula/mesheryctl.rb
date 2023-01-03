class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.40",
      revision: "27fa2daf59017306f38ffedaf74f82db0940f702"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cd95595dc5924f5e0ca6c38290abd085b2057c2c9796aeb01e88da388f7aa92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cd95595dc5924f5e0ca6c38290abd085b2057c2c9796aeb01e88da388f7aa92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cd95595dc5924f5e0ca6c38290abd085b2057c2c9796aeb01e88da388f7aa92"
    sha256 cellar: :any_skip_relocation, ventura:        "dcf12fb66964720a6f1a44d974604de48959d49ae05d96fefbc7f8d0c808131c"
    sha256 cellar: :any_skip_relocation, monterey:       "dcf12fb66964720a6f1a44d974604de48959d49ae05d96fefbc7f8d0c808131c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcf12fb66964720a6f1a44d974604de48959d49ae05d96fefbc7f8d0c808131c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec8ec5ea3aa33c89f455ab8e454b891837eaebbb64b37d413859c597c3518c0c"
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
