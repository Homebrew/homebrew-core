class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.119",
      revision: "02efefe899abda89990072ee05032ce01e9f0504"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f4865c764550ed5b5bb3251be5ebefab2d5d6644674a4f9eb9c7faa4ab09e07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f4865c764550ed5b5bb3251be5ebefab2d5d6644674a4f9eb9c7faa4ab09e07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f4865c764550ed5b5bb3251be5ebefab2d5d6644674a4f9eb9c7faa4ab09e07"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d3bf1129d137ab7a55e8c3db2e358e03f6a3af6874eeb53a18c7fbc06faa2bd"
    sha256 cellar: :any_skip_relocation, ventura:       "4d3bf1129d137ab7a55e8c3db2e358e03f6a3af6874eeb53a18c7fbc06faa2bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09a0ec01633cb5a6e58ccd9697c5fdcf3ae5637f7f6998f255c4dce6aeb95a93"
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
