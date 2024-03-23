class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.36",
      revision: "7df02f766192dfa361c9df734cb630ec4cc6499d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02efbefd2ecbd87288620e0286db32ae02ba754b97a39da17b01531fe8092cb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02efbefd2ecbd87288620e0286db32ae02ba754b97a39da17b01531fe8092cb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02efbefd2ecbd87288620e0286db32ae02ba754b97a39da17b01531fe8092cb4"
    sha256 cellar: :any_skip_relocation, sonoma:         "af65f95dfd2245d18e5dd7fc4adc7afc8010a6222ac1eeb0a1da5ce050adf9fd"
    sha256 cellar: :any_skip_relocation, ventura:        "af65f95dfd2245d18e5dd7fc4adc7afc8010a6222ac1eeb0a1da5ce050adf9fd"
    sha256 cellar: :any_skip_relocation, monterey:       "af65f95dfd2245d18e5dd7fc4adc7afc8010a6222ac1eeb0a1da5ce050adf9fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e840e71695bd4ca68e8327333bca2e216e08ce46524d25463270bb11e5644607"
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
