class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.59",
      revision: "4df8c1bca763577156911b3e300724eb8ab6a1ce"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f9b8c293e7e70cc528f2a039822bfc399cbd19de5fe176363d6a72948cc202d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf70943187cbd85206bcec630b20c262636de37c5e0124d6a9cdd7c3ee832a82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f9b8c293e7e70cc528f2a039822bfc399cbd19de5fe176363d6a72948cc202d"
    sha256 cellar: :any_skip_relocation, ventura:        "ceebd3df4c64ebe1116504412e6e5c4de7b0ee9a1585598570a067df78a18d0c"
    sha256 cellar: :any_skip_relocation, monterey:       "ceebd3df4c64ebe1116504412e6e5c4de7b0ee9a1585598570a067df78a18d0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "63bcbf9e84c1d371d569f49d7cfe71daa8e6e285b72f07090d7769d0f33030a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d217e2c4bc8e0af0a8c10bbaacd474f8c17c8af62624e12ae6174a5ee6b8a185"
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
