class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.162",
      revision: "b9c5c8b76d9a55a4a74ac385164a1a6511f03c92"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfc48467243909af9b675a250cd58e41296b9a0b51d0e2a974f530ca56630d9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfc48467243909af9b675a250cd58e41296b9a0b51d0e2a974f530ca56630d9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfc48467243909af9b675a250cd58e41296b9a0b51d0e2a974f530ca56630d9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7034d5bb08ab68ba658ab553b50380b8495e0fbb0cf52557646da9f39bc27b4"
    sha256 cellar: :any_skip_relocation, ventura:        "f7034d5bb08ab68ba658ab553b50380b8495e0fbb0cf52557646da9f39bc27b4"
    sha256 cellar: :any_skip_relocation, monterey:       "f7034d5bb08ab68ba658ab553b50380b8495e0fbb0cf52557646da9f39bc27b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbad06216476615e9d7c105110021780743276155a156921057a43e645a80f48"
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
