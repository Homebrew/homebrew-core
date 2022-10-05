class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.13",
      revision: "bfb6d31d24e6c47ce3bc228c7fb93260a9891cc4"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3662b6dba6ce7de60191e9367b8e824579d3b06e62f3b6bdcc14c59583e973a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3662b6dba6ce7de60191e9367b8e824579d3b06e62f3b6bdcc14c59583e973a"
    sha256 cellar: :any_skip_relocation, monterey:       "f86085683702895e49ac0da42436403cc440a849837e45c3e7da00f24b61cbfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f86085683702895e49ac0da42436403cc440a849837e45c3e7da00f24b61cbfd"
    sha256 cellar: :any_skip_relocation, catalina:       "f86085683702895e49ac0da42436403cc440a849837e45c3e7da00f24b61cbfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed56faacf71e1888e7524f6354bb9adbf19d73f2c996555683cbe648ef927c4c"
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
