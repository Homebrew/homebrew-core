class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.91",
      revision: "7ece05c1422a78c6bd92435e903c2975f43fe427"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a0c2c647d21073e88b4bff855d5d8ff865924aa074fc94d1a780df854af08f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a0c2c647d21073e88b4bff855d5d8ff865924aa074fc94d1a780df854af08f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a0c2c647d21073e88b4bff855d5d8ff865924aa074fc94d1a780df854af08f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "221d6cdcce074a9cba2e85f09c64523b8f854aa458254d5a56ab9f7946fc8d29"
    sha256 cellar: :any_skip_relocation, ventura:       "221d6cdcce074a9cba2e85f09c64523b8f854aa458254d5a56ab9f7946fc8d29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80e8ac1729b573b71249dbb00bafb533336c718eb3755ecc9b6597d90284167e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00a3247c64ed8a46f25bd584609ca9514d65079e064579d2f57227eae8e4ca1c"
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
