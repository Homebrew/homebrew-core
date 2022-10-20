class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.16",
      revision: "59f961fbde2f16b8275ef05a4e63766b847ecafa"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a64a7e4d612216975d36809bcedc636f8e59c3ab0344db97b4aaeb44319bd17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a64a7e4d612216975d36809bcedc636f8e59c3ab0344db97b4aaeb44319bd17"
    sha256 cellar: :any_skip_relocation, monterey:       "52d3d3e4f58b828d55805df078945e0499c58a8a2342a476bf202fddef91fcbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "52d3d3e4f58b828d55805df078945e0499c58a8a2342a476bf202fddef91fcbe"
    sha256 cellar: :any_skip_relocation, catalina:       "52d3d3e4f58b828d55805df078945e0499c58a8a2342a476bf202fddef91fcbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14f900320fc8bec7174fadd86f5f2367c3a99fdfcd4ec8a55ec24401531c72a7"
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
