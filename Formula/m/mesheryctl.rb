class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.44",
      revision: "ed26ed67a9ebfa40ae8a1f59156bc49978d2d359"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6fd7da7b404b55c99c75d131902007642de7280609761842ba99c71470bed00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a41eec81d57253c6a226b4c9ace108a5f82d78960e22a98e5b08a0bb8ca9e5d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee83627fb7f20b6009de71068744dd64e08a1d31c1c1764ebe5b99ef291ed9bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce3a7ca6d19683b1124102bc9c0a171b2d7d1a08bd747385fbd2ba4e2a33f7c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4582a4a0e30bf40a93c28d4d58435f22b2f4f6d2b35ee63b897ffdad5f58134f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71031f901207dce90a79bfc3744ed97471b60efb19d09bc3299d98ce0f879cf1"
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
