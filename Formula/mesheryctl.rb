class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.99",
      revision: "33ece5d95216d8a3ee1d7162c96ae76ea25052f3"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ae279904409516c14c8df76766d412e7c80a509a02bacd23b3c16d4f5a67fd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ae279904409516c14c8df76766d412e7c80a509a02bacd23b3c16d4f5a67fd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ae279904409516c14c8df76766d412e7c80a509a02bacd23b3c16d4f5a67fd0"
    sha256 cellar: :any_skip_relocation, ventura:        "79962c0c517c821eddadcfe0fb67242d171015585e0db126ae1551e0db6b884e"
    sha256 cellar: :any_skip_relocation, monterey:       "79962c0c517c821eddadcfe0fb67242d171015585e0db126ae1551e0db6b884e"
    sha256 cellar: :any_skip_relocation, big_sur:        "79962c0c517c821eddadcfe0fb67242d171015585e0db126ae1551e0db6b884e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a62573ed06c829f93b1dd7224ccacfaa5d747e9ed5b2cabbde308f4b224a8e9f"
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
