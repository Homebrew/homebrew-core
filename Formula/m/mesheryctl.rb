class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.25",
      revision: "05806e27df0486494d49a5a57aea4ecbb2209fd6"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7c30e8aeb6685847a68e88606b9eba37cbeb96d6d7fc0e0a1629dfa05feffad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb8dbb8bcbae50c6f0f3f3bee60d882e1ce16ef87dc7cb2cac7409c130792ba6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0e4cdd038c52d7e86a2e887311fcab00bad6febb023caa0b5bf1c03f37fb08e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a1f144172dc7de6c391cd3033206abf080ec1715a32f7d13a482e891450837d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c03bae60288754b5944b7b6f60756dc0a5203869c152e9ca471b48e485f07535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e68b783bf3f35af49fb952bf68b6928e1669a5d00b7fdb74664d490de67edc"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
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
