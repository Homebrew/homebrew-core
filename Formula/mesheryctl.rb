class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.37",
      revision: "83a6e7ba14b2ef0a94693a3e9b273357cb5e6c50"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa5cd4e1a5b4e493542a208ce246d4a109222c373a516f1fd373fdeefedbfa3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa5cd4e1a5b4e493542a208ce246d4a109222c373a516f1fd373fdeefedbfa3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa5cd4e1a5b4e493542a208ce246d4a109222c373a516f1fd373fdeefedbfa3b"
    sha256 cellar: :any_skip_relocation, ventura:        "59d72b6ae188744aded1a52473fbed4b3638853bc15b1f52ebfd5c2f693f030a"
    sha256 cellar: :any_skip_relocation, monterey:       "59d72b6ae188744aded1a52473fbed4b3638853bc15b1f52ebfd5c2f693f030a"
    sha256 cellar: :any_skip_relocation, big_sur:        "59d72b6ae188744aded1a52473fbed4b3638853bc15b1f52ebfd5c2f693f030a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94735b2af1d848083eeaa9d3a7670dfe2b05a03d398f3ea7adfe81afd2e6fa72"
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
