class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.19",
      revision: "f3def0a453284214550e7fa0b45b13cf065b2abc"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "229e1ef2daaa1431e8f2f5895deec538e35c31426dbb93541dc767f9260041fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "229e1ef2daaa1431e8f2f5895deec538e35c31426dbb93541dc767f9260041fa"
    sha256 cellar: :any_skip_relocation, monterey:       "cc1a5c3031437beae6d74bcb993a8ace2817a666993a0c060c528209ed771ebc"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc1a5c3031437beae6d74bcb993a8ace2817a666993a0c060c528209ed771ebc"
    sha256 cellar: :any_skip_relocation, catalina:       "cc1a5c3031437beae6d74bcb993a8ace2817a666993a0c060c528209ed771ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ae69dc20de244113b993aaeb17d5dc0823d6fb6f2fa11727b49e99a03debb75"
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
