class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.2-rc-1",
      revision: "8f86bab42cf593a0680e766dc732a766b2ac41ca"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c7ce998552f4b763f2152954d03f61d07acace78c0e17eafa0e877387083797"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c7ce998552f4b763f2152954d03f61d07acace78c0e17eafa0e877387083797"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c7ce998552f4b763f2152954d03f61d07acace78c0e17eafa0e877387083797"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e10ff4496ffdf8cadd75ed72fac12f520cdfabc4be42c22a768bcfe517f7168"
    sha256 cellar: :any_skip_relocation, ventura:        "6e10ff4496ffdf8cadd75ed72fac12f520cdfabc4be42c22a768bcfe517f7168"
    sha256 cellar: :any_skip_relocation, monterey:       "6e10ff4496ffdf8cadd75ed72fac12f520cdfabc4be42c22a768bcfe517f7168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f3428f8006d762e5ad5a6ead7d85d508269eb672a1cd19d42541ec6922a8ee0"
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
