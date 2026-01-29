class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.201",
      revision: "7327b9035e87ccc78b41f11ac805f01467159080"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b4fd777ef6243dbd505fa72d4d14b007c70d3d0aa31768df214606569bf6668"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8997b7ea1a3e8f2584e2ccf72e1de72806af529290538937b77631440fc03e1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "359e737ca1505a922de3f1dee22e2d202f61668225fdeedcb45f71ca3720b2f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c52d68cb1f5873aafaca061f8242e4b97756b045f9713e40270ccc568567b7fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56cd7968c6fe8f66c4f58166000d60769610a92bef63aa4ee5a6068f43c5f9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8398b9f435a7666483cb571c13529f725b3a82480b016681d5c29084cad78797"
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
