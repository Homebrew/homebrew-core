class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.71",
      revision: "8786c973238225c22472653ca3df1cb287e3034d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8ae36c93618b36c27b44f18e94a84d25ac05607f9ef9a39f637a8672be8ea93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8ae36c93618b36c27b44f18e94a84d25ac05607f9ef9a39f637a8672be8ea93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8ae36c93618b36c27b44f18e94a84d25ac05607f9ef9a39f637a8672be8ea93"
    sha256 cellar: :any_skip_relocation, ventura:        "7396a2efe568c9a1201b87ab99773c91f5c3f0b253f9145a5a696a8a6e6678fe"
    sha256 cellar: :any_skip_relocation, monterey:       "7396a2efe568c9a1201b87ab99773c91f5c3f0b253f9145a5a696a8a6e6678fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "7396a2efe568c9a1201b87ab99773c91f5c3f0b253f9145a5a696a8a6e6678fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23669bd95633d295c8f752bfb0db44908c46aa4ffd876c82d8215cfe0bb228f4"
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
