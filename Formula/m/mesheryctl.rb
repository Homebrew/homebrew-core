class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.88",
      revision: "4d627771cdbbded4728c44fb72f0ce101e0b8676"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adc823abc0c9f38aebe4a86715138e20f21887c46eb466b4e1f121b0fff960a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adc823abc0c9f38aebe4a86715138e20f21887c46eb466b4e1f121b0fff960a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adc823abc0c9f38aebe4a86715138e20f21887c46eb466b4e1f121b0fff960a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec7691f3abbca5dadca4c60c92a46b69e8ae5918f964a827c2ddb4b7a44b976d"
    sha256 cellar: :any_skip_relocation, ventura:        "ec7691f3abbca5dadca4c60c92a46b69e8ae5918f964a827c2ddb4b7a44b976d"
    sha256 cellar: :any_skip_relocation, monterey:       "ec7691f3abbca5dadca4c60c92a46b69e8ae5918f964a827c2ddb4b7a44b976d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdbad48ff71ed85aaa1195792259c26a106ba89ed54c9bec68a2f3ff54b4f8de"
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
