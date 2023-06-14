class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.94",
      revision: "242c3fd0b70c3094a67ac6b1f7f00a714a88ed7d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5d7e39e16aa63aed0b94955c581be730e2b51f07d20a6c7f1ece28d6efeb887"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5d7e39e16aa63aed0b94955c581be730e2b51f07d20a6c7f1ece28d6efeb887"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5d7e39e16aa63aed0b94955c581be730e2b51f07d20a6c7f1ece28d6efeb887"
    sha256 cellar: :any_skip_relocation, ventura:        "f3fb35f596f7eacf55a0918763459dbb88661d14640991bba8ddeb46843b529d"
    sha256 cellar: :any_skip_relocation, monterey:       "f3fb35f596f7eacf55a0918763459dbb88661d14640991bba8ddeb46843b529d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3fb35f596f7eacf55a0918763459dbb88661d14640991bba8ddeb46843b529d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbc31e1d4d3f9341b6eba0ccd30fd956c0f8af7a96034da0640ef01614270b5c"
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
