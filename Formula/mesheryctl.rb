class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.47",
      revision: "4c357f307f114450e641411f81be6991248ca504"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "847fb75585c77543b205b7c9062ef624e464c3117a94bf34ed6d57142ebffb93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "847fb75585c77543b205b7c9062ef624e464c3117a94bf34ed6d57142ebffb93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "847fb75585c77543b205b7c9062ef624e464c3117a94bf34ed6d57142ebffb93"
    sha256 cellar: :any_skip_relocation, ventura:        "ef52dbc62db8beadb2d9dd1ec64e5814d6f4cd3055be78a262ffb4e4c23063e4"
    sha256 cellar: :any_skip_relocation, monterey:       "ef52dbc62db8beadb2d9dd1ec64e5814d6f4cd3055be78a262ffb4e4c23063e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef52dbc62db8beadb2d9dd1ec64e5814d6f4cd3055be78a262ffb4e4c23063e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9af963de95664d02a148a5784e13147abe35f48e6793ab57140d83211de2875c"
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
