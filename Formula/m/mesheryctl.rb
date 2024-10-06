class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.116",
      revision: "b052911bc08ca28d7b686f02cd69d30fd3a8c633"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f49c5a5ac3ecf862bb0d23bb6abe2c9e25949c75c263dd981c0f3c201c5449f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f49c5a5ac3ecf862bb0d23bb6abe2c9e25949c75c263dd981c0f3c201c5449f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f49c5a5ac3ecf862bb0d23bb6abe2c9e25949c75c263dd981c0f3c201c5449f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8150ecdea77f171e8f45f2d5095cf65679254a971cd028123326ac67b854d3b3"
    sha256 cellar: :any_skip_relocation, ventura:       "8150ecdea77f171e8f45f2d5095cf65679254a971cd028123326ac67b854d3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "390bddcca9ebc182c3ec7b81118646ced3b12db16ad9beb27a71c74795f056ef"
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
