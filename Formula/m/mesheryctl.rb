class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.125",
      revision: "b76e88b4b175bc4d7e892bb10969556b7a4bd901"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "febb5bc7a3ade6c9e25d544c28139ab809565d7eebb6b213d3ad636714bb60f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "febb5bc7a3ade6c9e25d544c28139ab809565d7eebb6b213d3ad636714bb60f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "febb5bc7a3ade6c9e25d544c28139ab809565d7eebb6b213d3ad636714bb60f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "96a732b1f49c4d3c7d31d13a594343689688227c1dcfaba70935fe704ceb0b7d"
    sha256 cellar: :any_skip_relocation, ventura:       "96a732b1f49c4d3c7d31d13a594343689688227c1dcfaba70935fe704ceb0b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99fecbb8085562f280463cf1e3595b790be6b77b4e05deb2793dd3d29921ed1d"
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
