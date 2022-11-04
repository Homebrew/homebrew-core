class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.22",
      revision: "c22c818ad53eb1375721c871daeff09ca5d283fd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b97c61814e92ac27845aa60ff9f8055ded1122d885cc7dfa6626ecfde422f4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b97c61814e92ac27845aa60ff9f8055ded1122d885cc7dfa6626ecfde422f4f"
    sha256 cellar: :any_skip_relocation, monterey:       "626ff941627e78753f9f221db3f95d704562b16597249094a6b37303602b5362"
    sha256 cellar: :any_skip_relocation, big_sur:        "626ff941627e78753f9f221db3f95d704562b16597249094a6b37303602b5362"
    sha256 cellar: :any_skip_relocation, catalina:       "626ff941627e78753f9f221db3f95d704562b16597249094a6b37303602b5362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1d261d1c8506d5a1b955149b75f76e609b4501c8074d92874cc2b56ad7a1ebf"
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
