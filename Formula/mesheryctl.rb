class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.90",
      revision: "49e663d69d06dd99d416bb60057fb314756fb342"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed5cf0e966378c7f849b4c76264ed44aacae18da64fab5d9f14dd3a9acff8df7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed5cf0e966378c7f849b4c76264ed44aacae18da64fab5d9f14dd3a9acff8df7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed5cf0e966378c7f849b4c76264ed44aacae18da64fab5d9f14dd3a9acff8df7"
    sha256 cellar: :any_skip_relocation, ventura:        "c0b85b9b9e79fd6fb56a8c6f27afa0228d4d4635142c4e6d35585f1f54cdfee9"
    sha256 cellar: :any_skip_relocation, monterey:       "c0b85b9b9e79fd6fb56a8c6f27afa0228d4d4635142c4e6d35585f1f54cdfee9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0b85b9b9e79fd6fb56a8c6f27afa0228d4d4635142c4e6d35585f1f54cdfee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98ffe859fe12976b255e6e065604b8c300ac105023fa1918784a742bbf1cf10c"
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
