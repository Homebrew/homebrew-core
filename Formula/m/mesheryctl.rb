class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.39",
      revision: "0ca1b39119c725844429d06a3deed09958597633"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb9ecc7184fa4477efdaa0d917db780e247b80e960010dae4fb90025d3005e39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb9ecc7184fa4477efdaa0d917db780e247b80e960010dae4fb90025d3005e39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb9ecc7184fa4477efdaa0d917db780e247b80e960010dae4fb90025d3005e39"
    sha256 cellar: :any_skip_relocation, sonoma:         "55ebf558a4f92fbeac4fcfab6183d190d7bcd8462b0dc1b36880c2a28875df96"
    sha256 cellar: :any_skip_relocation, ventura:        "55ebf558a4f92fbeac4fcfab6183d190d7bcd8462b0dc1b36880c2a28875df96"
    sha256 cellar: :any_skip_relocation, monterey:       "55ebf558a4f92fbeac4fcfab6183d190d7bcd8462b0dc1b36880c2a28875df96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "125856b79f441a172de35da79abb803e265f01c995dfb04c007f7571dcabf608"
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
