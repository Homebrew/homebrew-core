class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.31",
      revision: "f0a58110d323a0fe06779d9ba91c97196d6974fc"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3175f031e4783477e8265e85b7a840a7f117de5c79e51de80a65f21d5816fcb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3175f031e4783477e8265e85b7a840a7f117de5c79e51de80a65f21d5816fcb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3175f031e4783477e8265e85b7a840a7f117de5c79e51de80a65f21d5816fcb1"
    sha256 cellar: :any_skip_relocation, ventura:        "e83e501436ee9ae22598166fc30540cff62737656d07f227ec8d8bc43016e0da"
    sha256 cellar: :any_skip_relocation, monterey:       "e83e501436ee9ae22598166fc30540cff62737656d07f227ec8d8bc43016e0da"
    sha256 cellar: :any_skip_relocation, big_sur:        "e83e501436ee9ae22598166fc30540cff62737656d07f227ec8d8bc43016e0da"
    sha256 cellar: :any_skip_relocation, catalina:       "e83e501436ee9ae22598166fc30540cff62737656d07f227ec8d8bc43016e0da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdeea4127b9390a7327c783aed9d3527e1326ee9dec5bb6128b5e8e91da959e6"
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
