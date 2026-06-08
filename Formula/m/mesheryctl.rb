class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.38",
      revision: "4e349cee21cbdbf14ce93ae8e5acd7d9c5d34d01"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c570e0dc52676d9ed9c618e1ebd10167395e9b70b01cb586602209758fd252f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36d464bb9d3b698d0cbb95c0d7b376da3989e06af5d0a8e92f821497fe0e08a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10e82d2096541ce3773ddb2d933f3c0d2b1357844925d3b428ed8c4faf512d14"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d341503d0740f38b03c7fbc3d6890ad616f59a8b864ae47fc975b7973aba86f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "112cdab121de42810a49ba5e12eaef0c9c4eddf312bafd91e37a8d4e1067338a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f1910a4e119426807c3a6cd4520228b0e0d91d17b437497163db0d3f4dcd485"
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
