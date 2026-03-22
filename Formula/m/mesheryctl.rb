class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.214",
      revision: "6161f0b1dada5a4ca9b88da25b553cb5e653436f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6f09de9909723ade959c86c73a636e0f2c5fcf1b3921fd195c5a02a99681a40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b090a2d89052539f2dbd8a81be32da008bd34799e18a35f520561c03c98be0a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8313393dfcf88966ab415cdcd415360ccb82c11dbbcb055e7a90e49405f14242"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce3cc9a81bb37205eaf01ef2db84bb0877d168377f6cf265395a47031bb8964c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e08436ca1212300a48f482e9f29152af4229826a9c68f107de7166a50cd3fed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e5ca66aa5b92af26419907266e3f67c604f540edabd18eb6dd28fdbeae73f59"
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
