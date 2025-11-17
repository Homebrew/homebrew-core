class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.167",
      revision: "e5940be44849b3ae3400aca203ae4fe13a646cc5"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52d85340ff08b9e3f19ccb3e75e85ecb9e50c52f767c52acd633994fd92f50b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52d85340ff08b9e3f19ccb3e75e85ecb9e50c52f767c52acd633994fd92f50b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52d85340ff08b9e3f19ccb3e75e85ecb9e50c52f767c52acd633994fd92f50b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6977b87edd302777af7106833b0bd5aaa07e3b14859b46fa42c6e12a2413f0f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "008f9b7d205dac776a15c40f614a6daab7c1efed93eb4c710247f313a7f19cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4843a7b1b16fac90563adab8439baceae1ddfac8a8971a26b81c6966d9e74f14"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

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
