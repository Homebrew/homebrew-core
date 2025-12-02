class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.176",
      revision: "8e53f3df33a0e2963c7771798c4e561f7fd95f42"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "508adc306609d7cb8f9bbcabe0316bef2a582ae948ee3b411c74f3276d13da88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "508adc306609d7cb8f9bbcabe0316bef2a582ae948ee3b411c74f3276d13da88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "508adc306609d7cb8f9bbcabe0316bef2a582ae948ee3b411c74f3276d13da88"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba3c107c1d8b5db40a2b8e1eeb8eda8cf822c5bdc04f2b4b3afc4a8d74f17ea1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56c8e28a5ac6412534f1e3633f04b5501eb3618b460040659933cb8a32c80ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9826bb6063a9fe685722fff06b57df64792213c97c21149c50629871ea558966"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

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
