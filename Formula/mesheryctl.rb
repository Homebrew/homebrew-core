class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.40",
      revision: "27fa2daf59017306f38ffedaf74f82db0940f702"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9011b254c073099bb07c951c8e4f5c1de171fa63982bf1b2ea49a9a7a1824b27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9011b254c073099bb07c951c8e4f5c1de171fa63982bf1b2ea49a9a7a1824b27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9011b254c073099bb07c951c8e4f5c1de171fa63982bf1b2ea49a9a7a1824b27"
    sha256 cellar: :any_skip_relocation, ventura:        "309401de6a9fc37e8e83a8317a4843d8aaf898d967e16cb21e6b53ed60f7b0f1"
    sha256 cellar: :any_skip_relocation, monterey:       "309401de6a9fc37e8e83a8317a4843d8aaf898d967e16cb21e6b53ed60f7b0f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "309401de6a9fc37e8e83a8317a4843d8aaf898d967e16cb21e6b53ed60f7b0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9c6846468c0a47ff26ca45bdb409e2dcbcdbeff8d2781b43b098229be4ff663"
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
