class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.0-rc.6ff",
      revision: "0b6e09624d7d35fb0ced04d851248831bdf663a7"
  version "0.6.0-rc.6ff"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a5d3747bf872875904009926095f2fad537e1ac50a2cc01e33461fe41c9995e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a5d3747bf872875904009926095f2fad537e1ac50a2cc01e33461fe41c9995e"
    sha256 cellar: :any_skip_relocation, monterey:       "6172988b427fe94143919e704c3c4419e6424cbb7d9ff52b6060968231ddcf00"
    sha256 cellar: :any_skip_relocation, big_sur:        "6172988b427fe94143919e704c3c4419e6424cbb7d9ff52b6060968231ddcf00"
    sha256 cellar: :any_skip_relocation, catalina:       "6172988b427fe94143919e704c3c4419e6424cbb7d9ff52b6060968231ddcf00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "165141163c40a59c9d0266ed02a837e711414daa0f479b0e9e50c95682372c26"
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

    output = Utils.safe_popen_read("#{bin}/mesheryctl", "completion", "bash")
    (bash_completion/"mesheryctl").write output

    output = Utils.safe_popen_read("#{bin}/mesheryctl", "completion", "zsh")
    (zsh_completion/"_mesheryctl").write output

    output = Utils.safe_popen_read("#{bin}/mesheryctl", "completion", "fish")
    (fish_completion/"mesheryctl.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
