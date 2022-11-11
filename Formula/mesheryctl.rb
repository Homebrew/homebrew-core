class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.23",
      revision: "4dcbc00e51d52c5d3ab0c0cfeddef286219de740"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46bdd2578cd0f64c756dba1177a02defb84f7fae6750c09e78a4df20083937e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46bdd2578cd0f64c756dba1177a02defb84f7fae6750c09e78a4df20083937e1"
    sha256 cellar: :any_skip_relocation, monterey:       "7e7c48a7276e8cf5868ac4895a21b2be8e0ce16b589e434c1f3598120c66e34a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e7c48a7276e8cf5868ac4895a21b2be8e0ce16b589e434c1f3598120c66e34a"
    sha256 cellar: :any_skip_relocation, catalina:       "7e7c48a7276e8cf5868ac4895a21b2be8e0ce16b589e434c1f3598120c66e34a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a537615c76414d8a08f9a2e3ad14dbd07d58695970d51cd93ba498e22c0519f"
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
