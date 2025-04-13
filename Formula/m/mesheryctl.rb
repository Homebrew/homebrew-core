class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.57",
      revision: "5236429a2adccab02713b8407c37f0f5f6663408"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79e4f75b198dba89fa736aadf8dabf1af6e93ebeec54b7d17ec3164aefb05c43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79e4f75b198dba89fa736aadf8dabf1af6e93ebeec54b7d17ec3164aefb05c43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79e4f75b198dba89fa736aadf8dabf1af6e93ebeec54b7d17ec3164aefb05c43"
    sha256 cellar: :any_skip_relocation, sonoma:        "96431b4e282335ddae13dd7ce0125bd17b725eb148b45e831a3f0420f73d237b"
    sha256 cellar: :any_skip_relocation, ventura:       "96431b4e282335ddae13dd7ce0125bd17b725eb148b45e831a3f0420f73d237b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54f1dc95f60169169de4919c072ec1e0496c44b546127fa607da693c1779b70a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bbcfedf30e4d0d54a2e11fe37f57a285c62e2617d56e2a8462cac276df84b2d"
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
