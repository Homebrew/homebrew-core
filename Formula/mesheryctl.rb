class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.51",
      revision: "7e31b1ace192e5c15a0ce110979de4d5e93fc660"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfbff15f958f7ff064588c04e4c86f31e1a026877294d176e1d3123bb792560f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54f1d98d81508b7c62181b917281a29098b4a8ae90ca0eabb2d052d728ecb1f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ab9b435410337319bde771e09acd518c8ee663351bcf6cb48c476160bed96d3"
    sha256 cellar: :any_skip_relocation, ventura:        "632313966a964e0d6d380ce262cdcacb81a3167dd2e2f8bc991afb375091fc75"
    sha256 cellar: :any_skip_relocation, monterey:       "35c19cd18f76404aea6ccb839a51d2ecf76f22b6c4fed862ced97477a786f5d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "715de5fad31497e1133c3d4d45b028153aac858f5d88b6a4785af6d1cdc501bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34d796149ac96bf88ade356b9bd8b94be2114b14abcdb40ad00f07ecbcd0063f"
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
