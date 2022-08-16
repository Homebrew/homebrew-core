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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef7bb4e0c4d1ad7f48fd0438e535c75988b36ecf0a5512284941c8cb8c278fd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef7bb4e0c4d1ad7f48fd0438e535c75988b36ecf0a5512284941c8cb8c278fd9"
    sha256 cellar: :any_skip_relocation, monterey:       "3e899bcc2604a59dc6276b178a031e146bb98bc423fac522f65482c791063231"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e899bcc2604a59dc6276b178a031e146bb98bc423fac522f65482c791063231"
    sha256 cellar: :any_skip_relocation, catalina:       "3e899bcc2604a59dc6276b178a031e146bb98bc423fac522f65482c791063231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7adad0eae53b40d9d7fcfa49cfe3d3dc7a226f66c26fa0e778db5b915716db08"
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
