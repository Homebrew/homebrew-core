class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.3",
      revision: "36580ecdd6bb81edf19277ea380266db067fc465"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf0ab919cb3b9fa4e89bcef45899445a7622a4ab20c2e02101a3aa881cc1b873"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf0ab919cb3b9fa4e89bcef45899445a7622a4ab20c2e02101a3aa881cc1b873"
    sha256 cellar: :any_skip_relocation, monterey:       "b0f4eec150b3593c356ee96316099b9e7ad3daa39989915b974183d9140de880"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0f4eec150b3593c356ee96316099b9e7ad3daa39989915b974183d9140de880"
    sha256 cellar: :any_skip_relocation, catalina:       "b0f4eec150b3593c356ee96316099b9e7ad3daa39989915b974183d9140de880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91dbc35f5c88de9ba40f856db3dd01b2f6af1e7d441442e80201b94b070ddff0"
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
