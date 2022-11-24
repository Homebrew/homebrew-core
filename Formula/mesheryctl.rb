class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.29",
      revision: "c71a0ba7d39ceaad12e69457f9ac9de5bbc344d0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a27470ac95466bfe861a90e686b38535a7c7f3034c6381d409d49dfe7b72ac27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a27470ac95466bfe861a90e686b38535a7c7f3034c6381d409d49dfe7b72ac27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a27470ac95466bfe861a90e686b38535a7c7f3034c6381d409d49dfe7b72ac27"
    sha256 cellar: :any_skip_relocation, ventura:        "6091383eb3e1ca8f53eea5674ad0ab814251f73e53de77816b2ff57bafec6861"
    sha256 cellar: :any_skip_relocation, monterey:       "6091383eb3e1ca8f53eea5674ad0ab814251f73e53de77816b2ff57bafec6861"
    sha256 cellar: :any_skip_relocation, big_sur:        "6091383eb3e1ca8f53eea5674ad0ab814251f73e53de77816b2ff57bafec6861"
    sha256 cellar: :any_skip_relocation, catalina:       "6091383eb3e1ca8f53eea5674ad0ab814251f73e53de77816b2ff57bafec6861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "589f6e1dc2b353a676654cdffbaf526af2bdfcd50e58aed80c13d48d17997518"
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
