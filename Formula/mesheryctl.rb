class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.75",
      revision: "8e16604199003e342a3cbd42bba51292ef7133d0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b99e50e0010ca2c8713162a89f266f37ada43374c453a808eaf18a66ccf90946"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b99e50e0010ca2c8713162a89f266f37ada43374c453a808eaf18a66ccf90946"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae4aab72ad7f6b7bab4ec962cd8a34beb8656722b1c90279da4d5e5f96a9e2ee"
    sha256 cellar: :any_skip_relocation, ventura:        "ba43fa466b3f5b1aa8d018301cd26a7399abb6ee01061ccb34604609a1a03918"
    sha256 cellar: :any_skip_relocation, monterey:       "ff3149a0d51fa1e0d18f90282d005ba28e7bac65e97bd87d64d3df1e57739321"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff3149a0d51fa1e0d18f90282d005ba28e7bac65e97bd87d64d3df1e57739321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "142e303f43e16f076abd2af0922e2fee40fcd8b453094ad7c4d9ae7e3b597992"
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
