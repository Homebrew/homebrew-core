class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.7",
      revision: "d8ee85c2a3efc7ae05931af0eed952b94a10d2b2"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de4ff17e328a6f9ddb8f76bfde0ee69bf5b8b7231c109439990ba1161d883105"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de4ff17e328a6f9ddb8f76bfde0ee69bf5b8b7231c109439990ba1161d883105"
    sha256 cellar: :any_skip_relocation, monterey:       "83d35fe18e3fa016e9cac82c843713539ae7456cbf896e5737bab0c80ecc6d36"
    sha256 cellar: :any_skip_relocation, big_sur:        "83d35fe18e3fa016e9cac82c843713539ae7456cbf896e5737bab0c80ecc6d36"
    sha256 cellar: :any_skip_relocation, catalina:       "83d35fe18e3fa016e9cac82c843713539ae7456cbf896e5737bab0c80ecc6d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d6fb1fa99d2592e1873f8904773fdcfed58c7fcc3519dac2509a8b1cf711db"
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
