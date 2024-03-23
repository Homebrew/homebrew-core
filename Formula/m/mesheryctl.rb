class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.36",
      revision: "7df02f766192dfa361c9df734cb630ec4cc6499d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e637fc2f1339bc45441ee93024493f0964686188ea1e1194c4df2de1e9c1cbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e637fc2f1339bc45441ee93024493f0964686188ea1e1194c4df2de1e9c1cbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e637fc2f1339bc45441ee93024493f0964686188ea1e1194c4df2de1e9c1cbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7ff9fba6f7f90c3cae0887bd1390049748c8aee6e3e680843da301243e06963"
    sha256 cellar: :any_skip_relocation, ventura:        "e7ff9fba6f7f90c3cae0887bd1390049748c8aee6e3e680843da301243e06963"
    sha256 cellar: :any_skip_relocation, monterey:       "e7ff9fba6f7f90c3cae0887bd1390049748c8aee6e3e680843da301243e06963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f32d853e0da5db4b17f3ed43adb725acd3ad1a40fe55192ff96abc26f6d2b1"
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
