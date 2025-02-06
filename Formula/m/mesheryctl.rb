class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.26",
      revision: "86495f679fe96eee59e6c6baddeb849fed657e38"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "105acb46f5a4062dc1384ee068d9d14ef6f06b15157595457b07b3981c9a64fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "105acb46f5a4062dc1384ee068d9d14ef6f06b15157595457b07b3981c9a64fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "105acb46f5a4062dc1384ee068d9d14ef6f06b15157595457b07b3981c9a64fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dd7a5c53c2cc498224a09a99a5905f7bdaa3419b6a22052a0610b76dc7813c5"
    sha256 cellar: :any_skip_relocation, ventura:       "3dd7a5c53c2cc498224a09a99a5905f7bdaa3419b6a22052a0610b76dc7813c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f352fd500e147b39d21e67bbebc3f3c999687b0f0c707ba50c150066e34d58c2"
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
