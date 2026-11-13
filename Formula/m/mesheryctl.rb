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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ffebeb434d3742a66cd149cd97435f848d105c580f8cbeb77fca31bc26d4c9e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0d0974925d610097506f07f39d79f118bfa694b8d16f0092eab512ac6a2541d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b0dd3fe6565c8ad7009b9b2936bd83cdd9355a934dff51492d98026bf96bcee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "42ed2cd90b9f6fd1fdd975d3f77a4b15a48891d62bec8e08655f603a8cb9521e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fa01a88d75f5529a7d96513e6956bc1626ba6e4f2739a18d28968d4883c4f8f8"
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
