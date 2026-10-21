class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.71",
      revision: "a2a47d386b6e922b9a75b37010161b0de6315a8d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4bc91eb2a8bef6f60fcfc2c95482a7ff0470fcdea10963fecd5259852dfaf634"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6deff8525727466418f287c386457066283386fcee5b1c8a81d00a7c4c5f147"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59dc0c6675a4a8ab3e55a96fe2408e6ece917ddcb31dec50db0341333c3ae6a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0497b7b3297f5caff4ea1138bc0817ed48c01829be18ff94e03569f233a88b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "deb0ebea832d1bc16532fd3d2e86b2f9dc4e1438cfebf918af0a45f1ee440212"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
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
