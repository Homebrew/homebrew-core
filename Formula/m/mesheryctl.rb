class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.33",
      revision: "ad9db94fc3dbdf71503a22ee7aadc9b966985a95"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c830ab2e41cdcafc284059253b071adbe121dd00584c4e9e8772cfb93f9dc6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c830ab2e41cdcafc284059253b071adbe121dd00584c4e9e8772cfb93f9dc6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c830ab2e41cdcafc284059253b071adbe121dd00584c4e9e8772cfb93f9dc6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "082434f66e5a22c462d0247ed46698102c98ca2c648c30c545d19dc5abe41d06"
    sha256 cellar: :any_skip_relocation, ventura:        "082434f66e5a22c462d0247ed46698102c98ca2c648c30c545d19dc5abe41d06"
    sha256 cellar: :any_skip_relocation, monterey:       "082434f66e5a22c462d0247ed46698102c98ca2c648c30c545d19dc5abe41d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac3aa5d5adb1eda6915a31c3ffced8ec727dd44a5c4c2a023615bb7f81348bd9"
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

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
