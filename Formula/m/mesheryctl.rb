class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.20",
      revision: "6e37e0d0b1e4f264cb946e91d5021ac57005c85a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "140117fd854b31a91eef431ab35a5badf430b8317770189710672230e4ff3ff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "140117fd854b31a91eef431ab35a5badf430b8317770189710672230e4ff3ff1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "140117fd854b31a91eef431ab35a5badf430b8317770189710672230e4ff3ff1"
    sha256 cellar: :any_skip_relocation, sonoma:        "23f461f771dc42558cff3521c055a0dad88b311643f2e0ef61430dd478057570"
    sha256 cellar: :any_skip_relocation, ventura:       "23f461f771dc42558cff3521c055a0dad88b311643f2e0ef61430dd478057570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aa2a03f51c68a569eafb453b62700bce262d8f76ceb53045d5bb2966de567a4"
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
