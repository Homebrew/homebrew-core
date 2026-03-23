class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.9.1",
      revision: "22a5fbdcf94992566eae650fc5eb73735463147e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70c0b16836aa062acde74005cb8392125d2f8f60834669749cdeea1eb28784d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cf71dca217e26a26ad70675f454ca76ec9c3d8d51fecb503197f24ea1a15733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "545f0ca9f3c1a03ec9dc6ed4767a3b766fd759fea8abc9978ac6a05bbda70eb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "94b0fd8b91b1087c17b469548ef3b691c7f7c3437cd63a3d373167593afd20f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5077bfdadc69ddd98c4ba8063873f76a583a21fe1810ab1f1d4d6d8badc69e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccf816cf3ffba85e7e1998ade31a8d3fb24ffe8c12ff2e8175bd229f83c9feca"
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
