class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.19",
      revision: "f3def0a453284214550e7fa0b45b13cf065b2abc"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27825f310f217946f26be7189362b10bec3251c7f12ef9dd6b64542b2cec8574"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27825f310f217946f26be7189362b10bec3251c7f12ef9dd6b64542b2cec8574"
    sha256 cellar: :any_skip_relocation, monterey:       "9628f347f79973f2e8b5d051e00d4203feb7df78aa21cebc3a61bf71340fc22a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9628f347f79973f2e8b5d051e00d4203feb7df78aa21cebc3a61bf71340fc22a"
    sha256 cellar: :any_skip_relocation, catalina:       "9628f347f79973f2e8b5d051e00d4203feb7df78aa21cebc3a61bf71340fc22a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "239b64a21c953a781644d37075fa48c4e57ece422b0fe02ee04ec8cd0290f073"
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
