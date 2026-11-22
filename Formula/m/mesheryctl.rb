class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.83",
      revision: "61bcd8c51ed265961023454ab0b95b924794e4c7"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "d81efef1b3e994c50ac896aac2efa8ca1aefa57516b0fa25562ba73a58a87673"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "682443cf2ce4bafd48f8bc7605a8654208091894f1a319036b3036b7899169c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3069bda847555cbc46bbfb89d9f0b944ead7474ebac2142d3cb3faf42a5fb2af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d2639c1f6b242af3e5a34afcfdf0749742e9887ebd366e5d66833154d86bda57"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b0b31246aefb76fc4c0383d8cafe389a168489e4544eddae987c4a2ae80b7dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d6641a1486952a91e98f78c772d1bbcef65bdac29c552bd4409702720372268f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
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
