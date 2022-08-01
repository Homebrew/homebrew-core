class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.0-rc.6f",
      revision: "9489a9ae2622d9302f24d570672755f6a7caf69e"
  version "0.6.0-rc.6f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa43790c32942b8d33afa7304cfaf1d0cfd8898275045aa69300456a55c2d5ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa43790c32942b8d33afa7304cfaf1d0cfd8898275045aa69300456a55c2d5ca"
    sha256 cellar: :any_skip_relocation, monterey:       "ba13382626450a5c9e5510f733fc7834fcb8101dd236002c93dc96acb8e247fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba13382626450a5c9e5510f733fc7834fcb8101dd236002c93dc96acb8e247fc"
    sha256 cellar: :any_skip_relocation, catalina:       "ba13382626450a5c9e5510f733fc7834fcb8101dd236002c93dc96acb8e247fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "314f60370334d33d7ba31b2df19673c1b84cb7be100bb66ed6e4f93870d9f659"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
