class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.15",
      revision: "2142459d2241d7f08c5d8ed7f7429ae0630f3bb0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0be95b5aeb9ecec73b5b6952009d07c83b7643aad016eca89cbeb661abd6b670"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0be95b5aeb9ecec73b5b6952009d07c83b7643aad016eca89cbeb661abd6b670"
    sha256 cellar: :any_skip_relocation, monterey:       "3524bfa6bad96a11c8c34b8afc9312a5e3cf2ac492f4c364758c84ba084cf98c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3524bfa6bad96a11c8c34b8afc9312a5e3cf2ac492f4c364758c84ba084cf98c"
    sha256 cellar: :any_skip_relocation, catalina:       "3524bfa6bad96a11c8c34b8afc9312a5e3cf2ac492f4c364758c84ba084cf98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "007e84f0325e5ce94088a7b7e88b273e46de3da7b431c6035ed75591be18416a"
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
