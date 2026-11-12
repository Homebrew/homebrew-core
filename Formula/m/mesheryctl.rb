class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.76",
      revision: "433283e8dcc32f1013f3fbcab0a2cab17a049e5c"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a62466272e7dd07a40dffe6f2b35cce944017ba08995fe3695a2ddc6d4cd290"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6eba13e45871cdcc0e2432c795751421bfb6dcd425d0af449482cbdda43b5c65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8e3e67f80f46235c840640c65190361e16ce979f17d3e72b7ec3d8625abba62"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1038423d4fb85badf93164c30aa894b20084af74757ce6bb8ec14f5f892ace47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ef1fbbd610eae212c666316c73e9ce27b381ee15b306d6bcae95aa4d9beb43f0"
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
