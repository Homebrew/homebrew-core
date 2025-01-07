class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.5",
      revision: "75ac55125d8e52bacc0a9455a9544662e2cf4f5e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b587b4eb16874ee9ac2aea2891b71e9f23359801b79987b4356cd6bc2f9fb16a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b587b4eb16874ee9ac2aea2891b71e9f23359801b79987b4356cd6bc2f9fb16a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b587b4eb16874ee9ac2aea2891b71e9f23359801b79987b4356cd6bc2f9fb16a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4977915b2580b9148d89fd2e0724665d9ab55beac78eeeddfb56f589873cbdb4"
    sha256 cellar: :any_skip_relocation, ventura:       "4977915b2580b9148d89fd2e0724665d9ab55beac78eeeddfb56f589873cbdb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "548ea01f0c6ad79d963783c176a10a11fbc3634389f83c9afe7ce8c2336d8309"
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
