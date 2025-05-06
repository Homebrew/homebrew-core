class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.70",
      revision: "173a192c60923d9934b8e1f666ddc4c02aed5b83"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c6d8f14ccbcd738a2d0a1e6fa2dd4578b7386e4b77c0d3af91b01516c5d5611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c6d8f14ccbcd738a2d0a1e6fa2dd4578b7386e4b77c0d3af91b01516c5d5611"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c6d8f14ccbcd738a2d0a1e6fa2dd4578b7386e4b77c0d3af91b01516c5d5611"
    sha256 cellar: :any_skip_relocation, sonoma:        "c228a7e81c97b121efc0e150fda2297e4cdbee2eda47237209f1435cb6c695bb"
    sha256 cellar: :any_skip_relocation, ventura:       "c228a7e81c97b121efc0e150fda2297e4cdbee2eda47237209f1435cb6c695bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e03b12d9235fdd40a7665a18b0feb3d30cff1c642c95b703fdacd565c15ba39f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f27c0628eebc0457239f488faa61bb89d3c9767b0b18ab2968f500a53eeb749"
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
