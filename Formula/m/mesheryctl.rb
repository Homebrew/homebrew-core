class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.133",
      revision: "8d136bd8f78f6c3656bf1e2c0a466a34b5d99122"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d35ad33ff5cca7757ddf92af8f04a62b6eff8b28bc457725efc35c4c9723834a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d35ad33ff5cca7757ddf92af8f04a62b6eff8b28bc457725efc35c4c9723834a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d35ad33ff5cca7757ddf92af8f04a62b6eff8b28bc457725efc35c4c9723834a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed310fe2dd314ea5429ecb7f7fac814d5bd2aca29823afc70557d88a60cbeeb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ddb11ee62ca9892001c8aae2522d632e4d3149df719f2d02fb499e4e7289785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6477a630b2d0736d2d321c433675bb5827d43988bd022c6ea68a6172574c2576"
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
