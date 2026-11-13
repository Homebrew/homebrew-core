class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.79",
      revision: "4a211505859d5da6b1215d8472b2fd4bb9a407e2"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "441efb029f6216e8879d273b9aad4f96586bf463423362d822c90e77f0a228fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab1412f187ffe941be507962d85df3708571ebcfbad583d57f9e28aa965a8906"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef8ab9effd763dbf33596d033c671c32af5de3134dcdc3d8e6959ec13a385ad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0da94aaa6237f0f71e9198b8dc073e1bae179cd8b0d5fda066932732483ee362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c3a0dce20930d6882622eefddb23fadc5c592e838f3d323427b663fcc218f27f"
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
