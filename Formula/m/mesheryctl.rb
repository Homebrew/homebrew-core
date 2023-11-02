class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.168",
      revision: "e131985ea8a60d4d4642ca96f4dc30b04434dca4"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a9f571cf34c327644075b6ee85686772c9872da85ade618587637db8b66114f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a9f571cf34c327644075b6ee85686772c9872da85ade618587637db8b66114f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a9f571cf34c327644075b6ee85686772c9872da85ade618587637db8b66114f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c692478eb401cd9cb811b1ee38b11fbb5190e3093e827bc23c75ad3bbb827563"
    sha256 cellar: :any_skip_relocation, ventura:        "c692478eb401cd9cb811b1ee38b11fbb5190e3093e827bc23c75ad3bbb827563"
    sha256 cellar: :any_skip_relocation, monterey:       "c692478eb401cd9cb811b1ee38b11fbb5190e3093e827bc23c75ad3bbb827563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5259b16293e00e12fec33d493bfe4e050d2c28a93ba36a4805505d450bcea08"
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
