class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.75",
      revision: "a83f2e854631cfff16c849dc09c948ddfa872ada"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ee1f4d402f0cc83ec83f5a48fc9e3dd5c3b0900967d762088a4b44569e6236f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d20475667e5af02fefa4527c0f4227a0a36d6c047e668ec7ce0e132ae12d5596"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2808d72d9d6e4ea4421fb2689d8fc214fa02c066fb4b8966bba49c348c60fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5464daf8b21cf7ceeda5d632df4712129577015788ba3941779da342d2587628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "67d6eda4be59fb555571ede4face0cd4077ab3c2fc7b17f5dbca64cf868d74d5"
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
