class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.22",
      revision: "c22c818ad53eb1375721c871daeff09ca5d283fd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69bea6df8f71d6a62df05dd8a3b9ec945ee7ae3e6535fdd533257815a7add81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b69bea6df8f71d6a62df05dd8a3b9ec945ee7ae3e6535fdd533257815a7add81"
    sha256 cellar: :any_skip_relocation, monterey:       "74fe86fd8a3030f9a4d3a942e0797c98f5b2d119c5d80b9b711c04e45d0d0445"
    sha256 cellar: :any_skip_relocation, big_sur:        "74fe86fd8a3030f9a4d3a942e0797c98f5b2d119c5d80b9b711c04e45d0d0445"
    sha256 cellar: :any_skip_relocation, catalina:       "74fe86fd8a3030f9a4d3a942e0797c98f5b2d119c5d80b9b711c04e45d0d0445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a69b11d704b96b84b1483417d30e7e1180d8b8645300dcb59dd4914884565c0c"
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
