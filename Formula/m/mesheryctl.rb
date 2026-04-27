class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.13",
      revision: "2c6de956d3816a89bf38b5e8c73a04670f5eff0b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87ce5035ed12767aeacfb665496c604a57c6b83c4dcb37b22354eb72e1587368"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef80926eb4f41bab41981d7fa7a5ca51c92e4a6f5e5162c807104c5690989184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75a5acce2873cc75098a9e3631e71e236f7f3d78c9da406e46780635eb9303ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "37c5e743d4ea6cba950c221e1d816aef798f23fa830d748b5e7e5724da5cd10e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a7c5bcd38807c08a9aa74666534ecb186fc83bc0623e7818c5abc328fb90627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db5775ff6551f8fe5027957cee3b3ed9713341a60415102642cf2c97ee5ef762"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

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
