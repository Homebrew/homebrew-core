class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.138",
      revision: "95fdf513b1568b876e318b005f3b8366d7310a05"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04ee172636fdc93ffa0bc0f82bf479df03eff946de512f61f729e30087af36bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04ee172636fdc93ffa0bc0f82bf479df03eff946de512f61f729e30087af36bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04ee172636fdc93ffa0bc0f82bf479df03eff946de512f61f729e30087af36bb"
    sha256 cellar: :any_skip_relocation, ventura:        "a0862b2f0349d9d509d6802b9dbe00be76d733908560889edbaa82e57df0a2de"
    sha256 cellar: :any_skip_relocation, monterey:       "a0862b2f0349d9d509d6802b9dbe00be76d733908560889edbaa82e57df0a2de"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0862b2f0349d9d509d6802b9dbe00be76d733908560889edbaa82e57df0a2de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4cf5d88d1ce5d8abb76f47a1a2bd6cda03d01bfbcffa1eb04e4a5183c52c26d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
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
