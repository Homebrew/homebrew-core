class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.54",
      revision: "fa82a7cbdc1b0f51c201fd3f4d9b37a93d66dd4c"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a42b4d03332ef4b96cc92b6ac023de23ecd079de276bb8e88ada803103cf0adf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a42b4d03332ef4b96cc92b6ac023de23ecd079de276bb8e88ada803103cf0adf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9cd3c7cd187233521b073e23ee9eac0318af278f3206c61c60197544eded080"
    sha256 cellar: :any_skip_relocation, ventura:        "8b83f4f4ca16a34c8ab8981eb51a2f22c1b95a1b448814d0227153ffa2968d6a"
    sha256 cellar: :any_skip_relocation, monterey:       "fae1465281cc78c26951afe05fbb011823182f60477b86d77064cac9da46d48b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fae1465281cc78c26951afe05fbb011823182f60477b86d77064cac9da46d48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948240aaccb3e0c75e61b98fd604b5eca46f2717a07764eb443f4443b07d024b"
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
