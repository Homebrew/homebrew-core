class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.133",
      revision: "899652b4c73945d88f7351d4e448aad6e313bdf5"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb8b1eae903bf46d7ad786a9a79544fb012babf68fdde568bba3778143a96d8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb8b1eae903bf46d7ad786a9a79544fb012babf68fdde568bba3778143a96d8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb8b1eae903bf46d7ad786a9a79544fb012babf68fdde568bba3778143a96d8e"
    sha256 cellar: :any_skip_relocation, ventura:        "d2874bf651daebed26e4a9c193a09d2e3ec1c16fa3318ba4e337b5b8a96da0bf"
    sha256 cellar: :any_skip_relocation, monterey:       "d2874bf651daebed26e4a9c193a09d2e3ec1c16fa3318ba4e337b5b8a96da0bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2874bf651daebed26e4a9c193a09d2e3ec1c16fa3318ba4e337b5b8a96da0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1de91eebbce01a6f6dc3046a2b0169e64309bd65bc69546273faff1dc10e872b"
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
