class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.21",
      revision: "3a07e398d61b5e0c84871cbc55336533b7ab42b0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "523586b748c272c80080abbeb0de73524d11cb89ab18495a646bb00e87da6332"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "523586b748c272c80080abbeb0de73524d11cb89ab18495a646bb00e87da6332"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "523586b748c272c80080abbeb0de73524d11cb89ab18495a646bb00e87da6332"
    sha256 cellar: :any_skip_relocation, sonoma:         "443d8f74ea7cd3c4e3f31a02bea1b2ca340b0637724767115a179e1224836402"
    sha256 cellar: :any_skip_relocation, ventura:        "443d8f74ea7cd3c4e3f31a02bea1b2ca340b0637724767115a179e1224836402"
    sha256 cellar: :any_skip_relocation, monterey:       "443d8f74ea7cd3c4e3f31a02bea1b2ca340b0637724767115a179e1224836402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a624782bf2ebf526ffde48cc517f6faa66031bdf2fce8eecb70fb52faaa80585"
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
