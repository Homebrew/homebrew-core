class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.5",
      revision: "fa049f14b08bd69681a48927aeef938de8014762"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a2579671559614a2bddc10703039cae1bb0507988e9b377097ebf4136aa8171"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a2579671559614a2bddc10703039cae1bb0507988e9b377097ebf4136aa8171"
    sha256 cellar: :any_skip_relocation, monterey:       "1304eb853e085a14c03ac635ea818101e2a29524219eb5865d4d6ff400fbf484"
    sha256 cellar: :any_skip_relocation, big_sur:        "1304eb853e085a14c03ac635ea818101e2a29524219eb5865d4d6ff400fbf484"
    sha256 cellar: :any_skip_relocation, catalina:       "1304eb853e085a14c03ac635ea818101e2a29524219eb5865d4d6ff400fbf484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9fc4b8c3c0aefc3191d71df6efef6ac7862829fe7df4c7d01d1839bc5ffa821"
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
