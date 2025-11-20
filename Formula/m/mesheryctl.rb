class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.170",
      revision: "d069e8dde4bd30c510feda96d112d59f056ddaf8"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af3cd5f3908e784301cebee388a3aaa8464365d129c4991363d35389d9b7ad30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af3cd5f3908e784301cebee388a3aaa8464365d129c4991363d35389d9b7ad30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af3cd5f3908e784301cebee388a3aaa8464365d129c4991363d35389d9b7ad30"
    sha256 cellar: :any_skip_relocation, sonoma:        "935361638afe2dc2ce1f98bc5ff09c64ed5e7968770d47e79f8866afac19ce3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "def2a801fa6317f789e4844b46dfb9a58aa35952a71cca232bb36c696ec62bb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e26af6c0b4f2c49261b0a64e9cde248490e0b3e1556ec4f00f312ce05b7edf67"
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
