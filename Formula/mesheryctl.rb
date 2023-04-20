class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.83",
      revision: "25acb01de7264fabf80d88cf596c6cd088592459"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8447cee6d26bebacad0bb76ba321c0c17c1a4b97447d7be65d579b8f240246d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2b8a082f3bd9d65fccd73832ba82699b5cbd90886cfe8cef3837a010a24da95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8447cee6d26bebacad0bb76ba321c0c17c1a4b97447d7be65d579b8f240246d8"
    sha256 cellar: :any_skip_relocation, ventura:        "ea820de221cac784c90c8242c4ee8c4fdbcdec9630e4cd937637906e539bf395"
    sha256 cellar: :any_skip_relocation, monterey:       "ea820de221cac784c90c8242c4ee8c4fdbcdec9630e4cd937637906e539bf395"
    sha256 cellar: :any_skip_relocation, big_sur:        "093aa026914b3b556a217b47967692e6ed071866d80eacb37904db6d5af4d714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f177289fa50783b30e2cc600e823a808ef8ec75da93723a590b4ad9e005744a"
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
