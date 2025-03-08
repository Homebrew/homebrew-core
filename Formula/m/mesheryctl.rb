class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.46",
      revision: "13a5f7f579000983a39fce9a8481015eb5ef06a1"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "814930209e36b84f7f53d470df40c6f0e1d3c2e2eda07f548180cefac260a444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "814930209e36b84f7f53d470df40c6f0e1d3c2e2eda07f548180cefac260a444"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "814930209e36b84f7f53d470df40c6f0e1d3c2e2eda07f548180cefac260a444"
    sha256 cellar: :any_skip_relocation, sonoma:        "63fd2c6f2bc95e5226063d5c56e8b975187ad987b740620baa552e1070fcae0f"
    sha256 cellar: :any_skip_relocation, ventura:       "63fd2c6f2bc95e5226063d5c56e8b975187ad987b740620baa552e1070fcae0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64237912f0bb8b2e8c4c31dd8294730c6f5a033260325784650dc64bef05c3fa"
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
