class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.0-rc.6b",
      revision: "bb80f4a97c8020aae6624c672ddd2a07e84c2733"
  version "0.6.0-rc.6b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

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
  end

  test do
    # We need 'yes' here because mesheryctl needs a meshconfig file to display version
    # of the server along with the cli. Since it doesn't exist yet it shows a prompt if the user
    # wants to create a default config file.
    assert_match version.to_s, shell_output("yes | #{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test existence of main commands
    assert_match "requires at least 1 arg(s)", shell_output("#{bin}/mesheryctl system 2>&1")
    assert_match "requires at least 1 arg(s)", shell_output("#{bin}/mesheryctl mesh 2>&1")
    assert_match "requires at least 1 arg(s)", shell_output("#{bin}/mesheryctl perf 2>&1")
    assert_match "requires at least 1 arg(s)", shell_output("#{bin}/mesheryctl pattern 2>&1")
    assert_match "requires at least 1 arg(s)", shell_output("#{bin}/mesheryctl app 2>&1")
  end
end
