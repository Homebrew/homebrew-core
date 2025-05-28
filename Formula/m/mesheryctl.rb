class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.91",
      revision: "7ece05c1422a78c6bd92435e903c2975f43fe427"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1bb88d1178cdf9cc06181bd6503b701b628df4c983f66e6e472f49fac459839"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1bb88d1178cdf9cc06181bd6503b701b628df4c983f66e6e472f49fac459839"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1bb88d1178cdf9cc06181bd6503b701b628df4c983f66e6e472f49fac459839"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7aee201bd125a99ceae613e85da7536149364f740093d24bbd28b5bd8b3cbc9"
    sha256 cellar: :any_skip_relocation, ventura:       "b7aee201bd125a99ceae613e85da7536149364f740093d24bbd28b5bd8b3cbc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b934a31ca1d5c4f2f03886c138d87597e254762ef2b54580942d480ac041a3bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c0e3af158e94209f16bc3ada260fd09d83c45e1267ff4f933f86ec2f2c818eb"
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
