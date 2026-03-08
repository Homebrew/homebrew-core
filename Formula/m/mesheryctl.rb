class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.208",
      revision: "a2bc2052ab436ffee52c8740c393ad032cd99411"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82cc8246b61ac26afb3b87ad68ee276c314ce6c04cc052f155a6ef165d54cf4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ca2115b8e1639560a6020ae601bd3f6c536950615bdbeea065dfb635ef0d402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ff1dd493b7fa42b5dc85e820cc94a806ce1851792f7e8cb4b0e1017c1675901"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b47e56561970f92b7d8d70196e4f49b9135bafe8c12e27eb7f8a3426371ab01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34fae1f1f9fa8dbd241425e4799ca2a552d5e032e9198ca7548c9b7b167314ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e3bf529e6702fba660806bc962b3996904890612ca93fe019c8c405dbdc2f39"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -s -w
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
