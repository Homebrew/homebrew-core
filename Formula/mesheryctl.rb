class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.105",
      revision: "1af9786bb8ed2dcb9e4928b15fda9582cfeecf51"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c28969f4a4763e4dbf492f98d29bdb04e685978705056a81badb44417a3e7b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c28969f4a4763e4dbf492f98d29bdb04e685978705056a81badb44417a3e7b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c28969f4a4763e4dbf492f98d29bdb04e685978705056a81badb44417a3e7b5"
    sha256 cellar: :any_skip_relocation, ventura:        "6ad8af4d0b1435fc8124a0a79fa36e6bd4fdc488a3294d55ff75734ed171ec38"
    sha256 cellar: :any_skip_relocation, monterey:       "6ad8af4d0b1435fc8124a0a79fa36e6bd4fdc488a3294d55ff75734ed171ec38"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ad8af4d0b1435fc8124a0a79fa36e6bd4fdc488a3294d55ff75734ed171ec38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dbee608963891707c78f8eae9f08a14d38206bb4c6964a1b631cfaf079562d9"
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
