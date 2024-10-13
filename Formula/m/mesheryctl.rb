class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.121",
      revision: "dc65251ec979a0003fbef7a1a61a3eb76cb3f040"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "463c189ddae093234d8af1442c62d66e9f0476f7a16ef5ed90f31c06264b4b1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "463c189ddae093234d8af1442c62d66e9f0476f7a16ef5ed90f31c06264b4b1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "463c189ddae093234d8af1442c62d66e9f0476f7a16ef5ed90f31c06264b4b1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "15acc11ed418f6f5650e8045fc2fafa40189b800c28b6f426e87278c04200102"
    sha256 cellar: :any_skip_relocation, ventura:       "15acc11ed418f6f5650e8045fc2fafa40189b800c28b6f426e87278c04200102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36be957f83eb2ee24fd09bc941633e366274097b7a3535e50be5ddaded43ed81"
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
