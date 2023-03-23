class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.67",
      revision: "55c41e56188268b5cd0aae0fcf1618a25556b9f9"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d21ed2a9dec0953b841e183c2bbff1b09c7fdc482219fa4cca45d79c4aa60375"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d21ed2a9dec0953b841e183c2bbff1b09c7fdc482219fa4cca45d79c4aa60375"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2c95240e2f3cfcee9da226cc47ac54149ae2da487f2bd0f198c068924f967a0"
    sha256 cellar: :any_skip_relocation, ventura:        "8edd3573cfbbad427835ba12886998d18ae49d9f94eac3f33fc8d1a6c8b6fc64"
    sha256 cellar: :any_skip_relocation, monterey:       "8edd3573cfbbad427835ba12886998d18ae49d9f94eac3f33fc8d1a6c8b6fc64"
    sha256 cellar: :any_skip_relocation, big_sur:        "9539d209730aa2654f1a63764161b23df243654860f2bab5d0d2b174ac993cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78161c7e6e7fcca70381cbc862e0eb6d339a098b856c1b81434e71e55ad93be9"
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
