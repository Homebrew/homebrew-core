class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.10",
      revision: "1194c06bbe01ce6d97d7f69e7fb59373ca6bd6ba"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3dc20836f3c4e6e843b47f169145e98d326eaeeefd352775fb44e17d9aec5c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3dc20836f3c4e6e843b47f169145e98d326eaeeefd352775fb44e17d9aec5c4"
    sha256 cellar: :any_skip_relocation, monterey:       "dad76175541cdebd3acd90e964f37f216bb620dcac301f6203d9cc7eab3e6f1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dad76175541cdebd3acd90e964f37f216bb620dcac301f6203d9cc7eab3e6f1c"
    sha256 cellar: :any_skip_relocation, catalina:       "dad76175541cdebd3acd90e964f37f216bb620dcac301f6203d9cc7eab3e6f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8d1e4eb863b231e381e7fe7718d0782c0cd2fc7a3eff3cbb25f85241fc31005"
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
