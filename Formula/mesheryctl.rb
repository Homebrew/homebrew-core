class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.67",
      revision: "55c41e56188268b5cd0aae0fcf1618a25556b9f9"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc3d509649fbb3ddf0989b6c9a429371be3ecb5f29f775f6eae5a6de69fdc9e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc3d509649fbb3ddf0989b6c9a429371be3ecb5f29f775f6eae5a6de69fdc9e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc3d509649fbb3ddf0989b6c9a429371be3ecb5f29f775f6eae5a6de69fdc9e1"
    sha256 cellar: :any_skip_relocation, ventura:        "10a8c09e1dd23b038b50a6d80245849bee3e98c4798487b3f8fed0e0d23b088c"
    sha256 cellar: :any_skip_relocation, monterey:       "10a8c09e1dd23b038b50a6d80245849bee3e98c4798487b3f8fed0e0d23b088c"
    sha256 cellar: :any_skip_relocation, big_sur:        "10a8c09e1dd23b038b50a6d80245849bee3e98c4798487b3f8fed0e0d23b088c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e019ca5efd0689225963a6caa170e13cabad25158b4ba749606b6893665a814f"
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
