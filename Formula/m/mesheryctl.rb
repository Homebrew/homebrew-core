class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.47",
      revision: "8b398a0abf83764ff5e5bb1ad95e3feba92523b8"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "903a8f07c9bc98a083cadac9f29ca3e45a5544da0b13d26fcc02eca6d1a2a56d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "903a8f07c9bc98a083cadac9f29ca3e45a5544da0b13d26fcc02eca6d1a2a56d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "903a8f07c9bc98a083cadac9f29ca3e45a5544da0b13d26fcc02eca6d1a2a56d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ea44df6bcf7813bb26de08afb843ea161e3f04c9ddaa7f0883eaa09c108e69e"
    sha256 cellar: :any_skip_relocation, ventura:        "3ea44df6bcf7813bb26de08afb843ea161e3f04c9ddaa7f0883eaa09c108e69e"
    sha256 cellar: :any_skip_relocation, monterey:       "3ea44df6bcf7813bb26de08afb843ea161e3f04c9ddaa7f0883eaa09c108e69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2912c094f1aa30b8187f58aec004d516851bcf3e9ab9f36608301291bad4b534"
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
