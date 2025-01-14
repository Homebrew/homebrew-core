class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.9",
      revision: "486bbaed1ad4d20f2284874ec81a628454e3f9ea"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e47e74483fd864f51cbd6a93e6c25f957e5fe832d0b514077f5606bc1b29121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e47e74483fd864f51cbd6a93e6c25f957e5fe832d0b514077f5606bc1b29121"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e47e74483fd864f51cbd6a93e6c25f957e5fe832d0b514077f5606bc1b29121"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a58e3c12a6ff84ab263eae155fdde74967acd10c9c05e12be46a72f5f86c40"
    sha256 cellar: :any_skip_relocation, ventura:       "f6a58e3c12a6ff84ab263eae155fdde74967acd10c9c05e12be46a72f5f86c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d9aeac8ddf81c578dca02ecb8cd8682c04da36e7ae31fad1f428da56b74046f"
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

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
