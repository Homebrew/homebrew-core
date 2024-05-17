class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.58",
      revision: "df635325ae7bfaaf980f08bf2ca2f04a1deb6338"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c63b74139750fcde290ed55e7179735af390b0f1e3b19cfd9fc62fd611c8482"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c63b74139750fcde290ed55e7179735af390b0f1e3b19cfd9fc62fd611c8482"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c63b74139750fcde290ed55e7179735af390b0f1e3b19cfd9fc62fd611c8482"
    sha256 cellar: :any_skip_relocation, sonoma:         "9077cb2bff20e1d0254cf4967c2b966b63557bad4ea7f94b3af13be0eb093dd1"
    sha256 cellar: :any_skip_relocation, ventura:        "9077cb2bff20e1d0254cf4967c2b966b63557bad4ea7f94b3af13be0eb093dd1"
    sha256 cellar: :any_skip_relocation, monterey:       "ccaaf4b2902df2b503ec4a4251c65fe6680b04ec832ddf5ba40fcf5523aeafd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02546c27371c365eff48dfeb958cf2b35ea2962eb7de2cddb4f976b254e7137f"
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
