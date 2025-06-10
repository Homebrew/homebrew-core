class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.101",
      revision: "904827b7807a5714901f68ecb893a37dbac31c8e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd18f86094ce9146c8bb294ebf28a14c23bba3147ab095ada32c3e4ad0dfeab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd18f86094ce9146c8bb294ebf28a14c23bba3147ab095ada32c3e4ad0dfeab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd18f86094ce9146c8bb294ebf28a14c23bba3147ab095ada32c3e4ad0dfeab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7debc417d09965386a28ca056c21bda133c131d2dcf440a69c6445fdf0604b2"
    sha256 cellar: :any_skip_relocation, ventura:       "c7debc417d09965386a28ca056c21bda133c131d2dcf440a69c6445fdf0604b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85cd8f71a9f62c8acb6c64e57169f351f2e69693c7a04434532a2b11ec8a525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4be1a9ac4bed349407d06895caa7d3b65e46533b265aef643c8f18e7ef570306"
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
