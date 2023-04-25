class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.85",
      revision: "64b8059a5e1815e76fe84a03c876d27673c40661"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca8695369c9efd197e5bdc7b6e9b3b5809c3144750669b363d02f39a42b53a49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9fce93f8df12feee5719aa60fe464955dec6c3d1f2a6478b0e549ac34361010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca8695369c9efd197e5bdc7b6e9b3b5809c3144750669b363d02f39a42b53a49"
    sha256 cellar: :any_skip_relocation, ventura:        "6b436f81d22b571ad9096ae9a57fbb8ecf7041aaf7d2169fc8f48370a3b39745"
    sha256 cellar: :any_skip_relocation, monterey:       "36d46c2a15e4319dc3fd602db0c3b6983f1b5c6c81a73da5a7ad7c283ec84720"
    sha256 cellar: :any_skip_relocation, big_sur:        "36d46c2a15e4319dc3fd602db0c3b6983f1b5c6c81a73da5a7ad7c283ec84720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a6af0cdb2aedbb75ae891c7256c2d5610975d373b2cfe0dfa0630b882b1eeaa"
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
