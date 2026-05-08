class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.19",
      revision: "beaf1d857db6a05d670419f95079cbde0bca7bdf"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c76fd5f6a4f9992327df32218dd2b44f8e706265c08c6fe7797b851682ca4bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff0a9e55bcabc5318dd55512dffdb0a0dfbb8a899ccb9826a9a17ab6af079cd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7a5ed2903e8a96682f2c2aaab55ec71b4781f1ef8cc47c84f4b2e969be70ebc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1cb56b34f85deb5c68b89ee8cc0148286b15307d031e98a50f01c2e9f844f8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6be66ee913aa626b99a4b41fdfe442e13358b3f312b067d21a21ec1ccb8508d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f485eb292efc6895a979bcd82d9f998469c48978bdc1c4c626b15bd316c2d9"
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
