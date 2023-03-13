class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.63",
      revision: "b370cf8f324f85995f80155cbef87146b6ee7945"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20a055ddfb453dcffc076a224ab19a8a74285b0b8d80f1ec8c3964751dfed6c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5faff89d2e7c5cb96ca9cf6079c4569db7773018e65fe4be753a189ec54139b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20a055ddfb453dcffc076a224ab19a8a74285b0b8d80f1ec8c3964751dfed6c5"
    sha256 cellar: :any_skip_relocation, ventura:        "70e4642049ca7e8fcf91770fc7e33096dd893765687a55d51de65d5a1a2a8ea1"
    sha256 cellar: :any_skip_relocation, monterey:       "70e4642049ca7e8fcf91770fc7e33096dd893765687a55d51de65d5a1a2a8ea1"
    sha256 cellar: :any_skip_relocation, big_sur:        "70e4642049ca7e8fcf91770fc7e33096dd893765687a55d51de65d5a1a2a8ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92c2f99f0642109628ac1738e19079c0342ef5aeaedbae4b6a9733cbd2739b0"
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
