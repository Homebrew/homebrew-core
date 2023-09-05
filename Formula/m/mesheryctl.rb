class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.135",
      revision: "82ca25aaf9e6f94f43e5b1231432aca0f8c05877"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c0e03e666388fa6887cc24f6ba87806e89434bccae707eb321432b1c13cef2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c0e03e666388fa6887cc24f6ba87806e89434bccae707eb321432b1c13cef2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c0e03e666388fa6887cc24f6ba87806e89434bccae707eb321432b1c13cef2b"
    sha256 cellar: :any_skip_relocation, ventura:        "f6bd12176bf00fec793289ecb33fe023de323cb14f58bf1fb33a33adee926783"
    sha256 cellar: :any_skip_relocation, monterey:       "f6bd12176bf00fec793289ecb33fe023de323cb14f58bf1fb33a33adee926783"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6bd12176bf00fec793289ecb33fe023de323cb14f58bf1fb33a33adee926783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4789158616030e8b10ad1a603c1a151cab2188dea19e180b6711275dc2e8615"
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
