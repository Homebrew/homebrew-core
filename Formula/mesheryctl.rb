class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.24",
      revision: "76698b1e85c7da92a182b87a1af8dca2dcdf48ff"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26799e200cec2e7c6457173f209ef3c6574c06a19115048975b836f6888e5a7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26799e200cec2e7c6457173f209ef3c6574c06a19115048975b836f6888e5a7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26799e200cec2e7c6457173f209ef3c6574c06a19115048975b836f6888e5a7f"
    sha256 cellar: :any_skip_relocation, monterey:       "500906ad627383785d676e44b6d8c6a4222330c67edf3cb4861d0283eecece9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "500906ad627383785d676e44b6d8c6a4222330c67edf3cb4861d0283eecece9c"
    sha256 cellar: :any_skip_relocation, catalina:       "500906ad627383785d676e44b6d8c6a4222330c67edf3cb4861d0283eecece9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65fb81c11ea34d8fc6570862f2b0b1b7120831988b813843d7f966f8765fcd0f"
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
