class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.0-rc.6fd",
      revision: "f4e1ced2f1bb8f48022f9430cd8be19ee3fd8d02"
  version "0.6.0-rc.6fd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8580384942d69116726d4829eaf95d0e29f927e47774834b0a8a6b3b3812dcbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8580384942d69116726d4829eaf95d0e29f927e47774834b0a8a6b3b3812dcbe"
    sha256 cellar: :any_skip_relocation, monterey:       "0d18d4f125bc9bdb600bbeadaef02136ee75d5851146ac014327b3175528b213"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d18d4f125bc9bdb600bbeadaef02136ee75d5851146ac014327b3175528b213"
    sha256 cellar: :any_skip_relocation, catalina:       "0d18d4f125bc9bdb600bbeadaef02136ee75d5851146ac014327b3175528b213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "954ff72e67ab50d83e8ab8209fbd423720d26707714af480c951e75117e42e5e"
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
