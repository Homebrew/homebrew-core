class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.35",
      revision: "f845274be19547a43efa7c729ca2c1bbb12abd7e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0275a568605a40b0c5c84a6c198043ba226942248ad854261ef7fdc885b27839"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0275a568605a40b0c5c84a6c198043ba226942248ad854261ef7fdc885b27839"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0275a568605a40b0c5c84a6c198043ba226942248ad854261ef7fdc885b27839"
    sha256 cellar: :any_skip_relocation, ventura:        "f7727f9e0d147348dd87ea28607c6a03397d5c153abae3d9ba03b8dc13ed6cf2"
    sha256 cellar: :any_skip_relocation, monterey:       "f7727f9e0d147348dd87ea28607c6a03397d5c153abae3d9ba03b8dc13ed6cf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7727f9e0d147348dd87ea28607c6a03397d5c153abae3d9ba03b8dc13ed6cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d18c86941fb98ca0238b33a0e9edf7efffeba228e0375462d762cc95dd68d0"
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
