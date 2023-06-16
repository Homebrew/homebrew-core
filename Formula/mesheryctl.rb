class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.96",
      revision: "57e5a3c14859d83eb49fb22a4010f318fd1ff999"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dad75f9ad3250d689cc1881fe1687e0b8ed90107516d0defdeb0eed163cd30f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dad75f9ad3250d689cc1881fe1687e0b8ed90107516d0defdeb0eed163cd30f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dad75f9ad3250d689cc1881fe1687e0b8ed90107516d0defdeb0eed163cd30f"
    sha256 cellar: :any_skip_relocation, ventura:        "a5a2433f794b6e02bf47bddb66e1a6124fde0cfd4be8732f6f4a931b3dfd1f81"
    sha256 cellar: :any_skip_relocation, monterey:       "a5a2433f794b6e02bf47bddb66e1a6124fde0cfd4be8732f6f4a931b3dfd1f81"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5a2433f794b6e02bf47bddb66e1a6124fde0cfd4be8732f6f4a931b3dfd1f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e374877571bbb1d076694183db6d9b4f3626905335c26542fc49060fddb3f587"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
