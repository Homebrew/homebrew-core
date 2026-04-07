class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.4",
      revision: "3aa5bb8107a96ce4bcd63149719d041021d6e6ae"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40a62f58916d78aa866c5987faaf8a78aa55d8c51cf7d8d83044c265d0426ecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e28a05e0d9e0060d5410cd971c1eec19e48e1d17221b9f9f0bdec8a7653c59d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "584bf9a984ae2e8bfa56fc36eb986ad4b94cd0cc836535706a7bcb2f866ad50d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f0c410dbc82c9e4deb15186e3c1aba064a06d8505b94ee9f5553de8227b8827"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c53d4cca6e0ad4130f963d33a31e139ab9ba8e070abdbf546dc6b40a8fe52b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "056b8bb433b3409b20d7b3d9ac3e52c3b3ffd01f30d1573e02a559e6548d89ed"
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
