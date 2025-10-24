class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.142",
      revision: "da1b8238a12fff012aec04d4f22d085ab8c64ce7"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93cd0f730447d9356018fa4e4b6cf0abe1dc8d931d52d48f11addd3f5746e272"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93cd0f730447d9356018fa4e4b6cf0abe1dc8d931d52d48f11addd3f5746e272"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93cd0f730447d9356018fa4e4b6cf0abe1dc8d931d52d48f11addd3f5746e272"
    sha256 cellar: :any_skip_relocation, sonoma:        "09108b20bd773a1d704fb95e8f7fe0893e85b0f6deb8702377fd8fb9b99fa8dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7672523660dc589169c6ad60c564887c70c10496c0cd23506d8f4f0d794e1bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b1a6b34ae765d3400b79898e4ebe05a01cc3eb4e94f10ea2f3716652ab231b3"
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
