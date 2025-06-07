class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.100",
      revision: "8b63a09f63d673fb8c448a9c888ca68fb5557ed7"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "774fdd0a30edc9920f6ea4066cda5e46ad7606ca3943fdab4288e3df24439504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "774fdd0a30edc9920f6ea4066cda5e46ad7606ca3943fdab4288e3df24439504"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "774fdd0a30edc9920f6ea4066cda5e46ad7606ca3943fdab4288e3df24439504"
    sha256 cellar: :any_skip_relocation, sonoma:        "2052d14435d7a8e158193adc0bdcaadbf91018eab38bf554f2a9d2396f1fca2b"
    sha256 cellar: :any_skip_relocation, ventura:       "2052d14435d7a8e158193adc0bdcaadbf91018eab38bf554f2a9d2396f1fca2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c16118946f2f8a160da56da71088c5a0b1c6dcb929c476416a094d24dda23cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be2b5df42d882f739e8e185f34d5e94c6c045e146290c5c174397c45f9750963"
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
