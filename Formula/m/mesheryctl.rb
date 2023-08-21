class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.129",
      revision: "2d69c51ae4ac1ace5e2967bf14636db2f84db5e3"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ccfb7fe253a578d25fd27016fbc6f38f73b669dd84808e8a25e947fd89e1ac1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ccfb7fe253a578d25fd27016fbc6f38f73b669dd84808e8a25e947fd89e1ac1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ccfb7fe253a578d25fd27016fbc6f38f73b669dd84808e8a25e947fd89e1ac1"
    sha256 cellar: :any_skip_relocation, ventura:        "d6fcaa297ad81dba4001eb59601d79df1a906ca446556bc3a919ea7f95319d69"
    sha256 cellar: :any_skip_relocation, monterey:       "d6fcaa297ad81dba4001eb59601d79df1a906ca446556bc3a919ea7f95319d69"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6fcaa297ad81dba4001eb59601d79df1a906ca446556bc3a919ea7f95319d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4cd954f7d5d46fec5ae44c464e0c4013b978d6da016d10f835de78d1f8fc04a"
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
