class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.16",
      revision: "59f961fbde2f16b8275ef05a4e63766b847ecafa"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "967ee147fd025a62b8ab3918c4aac9fcd9540192d8a5a7e9a25db97bec67b6e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "967ee147fd025a62b8ab3918c4aac9fcd9540192d8a5a7e9a25db97bec67b6e8"
    sha256 cellar: :any_skip_relocation, monterey:       "a02f1376cf614e8fe46a4a25b2bf5712cc7283e39cbbb17603e7f366a148b789"
    sha256 cellar: :any_skip_relocation, big_sur:        "a02f1376cf614e8fe46a4a25b2bf5712cc7283e39cbbb17603e7f366a148b789"
    sha256 cellar: :any_skip_relocation, catalina:       "a02f1376cf614e8fe46a4a25b2bf5712cc7283e39cbbb17603e7f366a148b789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afb3305c1048741b2371bd27a4709702f6f63e73fa03aa2e70cda32719af0297"
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
