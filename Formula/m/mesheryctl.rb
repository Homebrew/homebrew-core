class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.82",
      revision: "3a3c535fd9d2745126975744956962a1724d5fd5"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc29382b69533464003188ca3146784fc96331d863596e38c06243dc1c2c39af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19df03ea49184ba424200ec2864c8e682991edd50b33c2b0037f72cc194e2d51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f4e7a081bb8f43144aedd4a40a01d861fe281e1284c141ee4f1e3a5ebd6e3fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e836026abf663c1648b6760e2831435cde7ddc765720385e46fcb78ab2d4578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e0929c2fa0d2f2bdab5ff24698b2e174ca97ca1303079f1a2c8b6cb96fd6c328"
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
