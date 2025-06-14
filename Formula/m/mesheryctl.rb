class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.103",
      revision: "89829e9edc6cc4275aaa444240f6f593917abd36"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b56ac745540b246bbe87b728299bc29827a228031a3505f5bcfb57a208151212"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b56ac745540b246bbe87b728299bc29827a228031a3505f5bcfb57a208151212"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b56ac745540b246bbe87b728299bc29827a228031a3505f5bcfb57a208151212"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce857abd833b0db8a3eff0117d472bbe17337147c7916a122b18801065c1fcc1"
    sha256 cellar: :any_skip_relocation, ventura:       "ce857abd833b0db8a3eff0117d472bbe17337147c7916a122b18801065c1fcc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51f0884a54f291ae574fcb7ad44c3c20aa08188f0a7122a273c8110e71d56c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2371482b06686902148246ea36fa4edb3813ee429f46948b991917248d125b95"
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
