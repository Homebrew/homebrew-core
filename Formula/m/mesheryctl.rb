class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.172",
      revision: "8a7516d4c6152a021ce3127a4f20d7800933071b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d23a69b35796c15cb2a5e503134cf85ef96e9fb8174f5f572bcb2f0334421868"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d23a69b35796c15cb2a5e503134cf85ef96e9fb8174f5f572bcb2f0334421868"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d23a69b35796c15cb2a5e503134cf85ef96e9fb8174f5f572bcb2f0334421868"
    sha256 cellar: :any_skip_relocation, sonoma:        "400c3959a327fd710abcfa3b54fde08a418524bc005b8d74fed4191b4e39d993"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86183ae7d0c2fb4438e9db9ed0e089e004ba95a9d5bfa3b39196526a1ab7dafb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1736cf77396cf8599ac37b0160a90da4fadc2ea41c0f98f8edc514d270e1394f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

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
