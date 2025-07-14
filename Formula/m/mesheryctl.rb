class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.119",
      revision: "52c0dcf70a989716f59527aa5e31c41812001254"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36fea705947de8ea09693a913ffe26d610e8c3a41a342ac425a6245977674207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36fea705947de8ea09693a913ffe26d610e8c3a41a342ac425a6245977674207"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36fea705947de8ea09693a913ffe26d610e8c3a41a342ac425a6245977674207"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d2aa93f4ca88f59c5088a8f9bd7f3b9b03d5454054d9086612bdcf60b0f7aa5"
    sha256 cellar: :any_skip_relocation, ventura:       "9d2aa93f4ca88f59c5088a8f9bd7f3b9b03d5454054d9086612bdcf60b0f7aa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "229d8139d3ccc219e1fb7595db49d1911ed4cc9c2f883a599caf41912e1db515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1b2ef6b8a9f0dcecad145b33b994aabbd7c0137f863165286756e3a9d00bd5a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
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
