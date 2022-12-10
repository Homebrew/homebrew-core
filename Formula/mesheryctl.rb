class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.34",
      revision: "dc6de722075487a98f289cc8bfdb7969aadc09dd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc9c9d34c9076c5b62ca306f5d435eeba20e0978834ac5e65429f841f18371b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc9c9d34c9076c5b62ca306f5d435eeba20e0978834ac5e65429f841f18371b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc9c9d34c9076c5b62ca306f5d435eeba20e0978834ac5e65429f841f18371b9"
    sha256 cellar: :any_skip_relocation, ventura:        "87890c7a536b390886d6182e8cab8dfedc1f691a4df7e5924cf32647c8913f15"
    sha256 cellar: :any_skip_relocation, monterey:       "87890c7a536b390886d6182e8cab8dfedc1f691a4df7e5924cf32647c8913f15"
    sha256 cellar: :any_skip_relocation, big_sur:        "87890c7a536b390886d6182e8cab8dfedc1f691a4df7e5924cf32647c8913f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55c6866ad13db7276a5c694ee62a1e35df530a3d34143b361c993a733dcbf966"
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
