class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.5",
      revision: "0961c13b51f49b36289c7413236df2af6f1fe089"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02b95da3b997d3e7d9e0ee494451330271724a957a2b74adf190697eca8badfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85968f1b6cac650fb350ba4b3a145724788244deaf576f4787f1c0634b58df91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87198b69946fc3dcb5775336f5e0437ae7050300c3b7f6cf74406a8c45222c4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b268ba6f7d6fdd13a6cc3ffd3b8b89d460a5f58ce6de2635c3f17b076de94d53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29a2150fc8d9bb188515b6410414c754d16675245effcc49dae21cf318ff13dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02148834afb9fd2fa8d06debcbb6c872a2a460a068c7788b5d1878c47d18041"
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
