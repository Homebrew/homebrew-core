class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.98",
      revision: "8099950643f4c8b374e1295d3b1a40ae4609f8df"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6fdd11739072f0bc3ca0ffc57e24e55330f7ea267fe76e1d5205f0bda4d5415"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6fdd11739072f0bc3ca0ffc57e24e55330f7ea267fe76e1d5205f0bda4d5415"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6fdd11739072f0bc3ca0ffc57e24e55330f7ea267fe76e1d5205f0bda4d5415"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e9d9c0f5f8a18b1bde0a479d3e28095e3f394dc0b549812f90e77e5c3b83c70"
    sha256 cellar: :any_skip_relocation, ventura:       "0e9d9c0f5f8a18b1bde0a479d3e28095e3f394dc0b549812f90e77e5c3b83c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15566702005bc3879752fdf7f119a918498cf3c66bf5c1002f2e2cb32c4587ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a7b42585a81fa55c4536a6debf606ea7428644d100fc89fe6e760a9f33e4c2c"
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

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
