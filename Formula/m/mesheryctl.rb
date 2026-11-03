class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.75",
      revision: "a83f2e854631cfff16c849dc09c948ddfa872ada"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43a232d374e40dc80d8a5515020c19cee29caa234c61b941c9d5f92676394050"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "770668c270be4017660d1584999ba146c077faf7fca8fde61d846c3b3b7bdf8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d679e028145976ea3602ee1dbfed9efe266860a0045ea3f41ec5646a168d3d5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d0ad54395e2e4386bf6784346886645fccb9f04c11e53caddcf418bd7da472ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b4a007c23de8f84dcdf67ad470b2a97458e537447de2fd4ef21db5dbbcc16cae"
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
