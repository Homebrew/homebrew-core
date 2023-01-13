class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.42",
      revision: "9a61588a2cfb1a47a494599337bc1eda01aae90e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a226115fed85b9417e9d94163f3a7afc0e35e135f337204cf82161f2c99be1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a226115fed85b9417e9d94163f3a7afc0e35e135f337204cf82161f2c99be1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a226115fed85b9417e9d94163f3a7afc0e35e135f337204cf82161f2c99be1c"
    sha256 cellar: :any_skip_relocation, ventura:        "d0d9fd353998fdb39c81339ffa35e2a820f07652d23c3da4f3feafc1b796bf54"
    sha256 cellar: :any_skip_relocation, monterey:       "d0d9fd353998fdb39c81339ffa35e2a820f07652d23c3da4f3feafc1b796bf54"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0d9fd353998fdb39c81339ffa35e2a820f07652d23c3da4f3feafc1b796bf54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f8983220cdf98a656567310c60338ad99570e5b338480147989a3585ce433c5"
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
