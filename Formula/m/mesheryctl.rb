class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.59",
      revision: "abe24cdb79d0c091d3346e68491d3d7772a812c3"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3694b6fc79e8e36b834bc52fa13100556857fc8a9d4c4861643eef10208c8820"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3694b6fc79e8e36b834bc52fa13100556857fc8a9d4c4861643eef10208c8820"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3694b6fc79e8e36b834bc52fa13100556857fc8a9d4c4861643eef10208c8820"
    sha256 cellar: :any_skip_relocation, sonoma:        "55dbc772a4fadfeddfd6c4a6e9a74d3e2231c4cf36cbfb34030b9c7e540424e9"
    sha256 cellar: :any_skip_relocation, ventura:       "55dbc772a4fadfeddfd6c4a6e9a74d3e2231c4cf36cbfb34030b9c7e540424e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05034f5ecd90a9533782fdbfb5ad9442e7bf674033c34df820f67b5821f49f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cffe47c7848a06f5b1488a62f03552232990c888f6f81c707491d9a8e085b20"
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
