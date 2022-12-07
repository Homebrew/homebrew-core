class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.33",
      revision: "8599864c4c1fe962f49d9e0c2ab6e4285a005e9a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4e657ca6866fe52155d64356a5da635f0a8591d1a7b23673885fed6bdcb8a19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4e657ca6866fe52155d64356a5da635f0a8591d1a7b23673885fed6bdcb8a19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4e657ca6866fe52155d64356a5da635f0a8591d1a7b23673885fed6bdcb8a19"
    sha256 cellar: :any_skip_relocation, ventura:        "7a665e951a759aa4f8320b0762237c0cf63d1582fa89e51c3176a51c0536036e"
    sha256 cellar: :any_skip_relocation, monterey:       "7a665e951a759aa4f8320b0762237c0cf63d1582fa89e51c3176a51c0536036e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a665e951a759aa4f8320b0762237c0cf63d1582fa89e51c3176a51c0536036e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fbcd126394315918d799517d251c10338e8c052d336ab20248cdbb4586444d4"
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
