class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.39",
      revision: "7180af80e44a318457ff65eda85793c8d93bc97d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf5f9735605b3f31a1ed794bb2b395583bf830574857c6cad7cadb77b2ce01c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf5f9735605b3f31a1ed794bb2b395583bf830574857c6cad7cadb77b2ce01c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf5f9735605b3f31a1ed794bb2b395583bf830574857c6cad7cadb77b2ce01c9"
    sha256 cellar: :any_skip_relocation, ventura:        "87b3b7cc17e0e07f73d7290def441f7f7315b4bb2277db9727868c8461b47dc8"
    sha256 cellar: :any_skip_relocation, monterey:       "87b3b7cc17e0e07f73d7290def441f7f7315b4bb2277db9727868c8461b47dc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "87b3b7cc17e0e07f73d7290def441f7f7315b4bb2277db9727868c8461b47dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f22f330d32fe83a6e6fa6e3537294c640cb40666f59f405c4470d3d0da7a29cc"
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
