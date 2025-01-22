class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.19",
      revision: "3fef916e0b295eab29cf8287eff644220b0db85d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c7bbabcc0a1c42b1e70a81e1c5ea14fd305c849be609f71ac05b9ffe28a95a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c7bbabcc0a1c42b1e70a81e1c5ea14fd305c849be609f71ac05b9ffe28a95a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c7bbabcc0a1c42b1e70a81e1c5ea14fd305c849be609f71ac05b9ffe28a95a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad33e8d8d01f3d7ebdb819846b26aeec60d861518f3f0e029345a6a51cd0e672"
    sha256 cellar: :any_skip_relocation, ventura:       "ad33e8d8d01f3d7ebdb819846b26aeec60d861518f3f0e029345a6a51cd0e672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8011bead12ae263d80af92b14f91aedeb5eeb4714434f503298e25df01117f35"
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
