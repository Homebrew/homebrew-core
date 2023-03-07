class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.62",
      revision: "958a7875a015e182c5236ba53f1f9f921b5db342"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6474979737f40646412e4e3c1c4609a1cc1c462037153fb25cd2a1e77a15d137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6474979737f40646412e4e3c1c4609a1cc1c462037153fb25cd2a1e77a15d137"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b14180a248e431eb987dc0091eb5ebb576431930958dcc6ac5046a174cc31ff"
    sha256 cellar: :any_skip_relocation, ventura:        "3317472a5f34a94e5c00c7af6cb4e39309adcec836ceb8ab2eeb88e0261d8fe9"
    sha256 cellar: :any_skip_relocation, monterey:       "3317472a5f34a94e5c00c7af6cb4e39309adcec836ceb8ab2eeb88e0261d8fe9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c62820d5f7579514e61800a41a6a001168264fe83101402609937c79409c6538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f8624709553091cc3536b412157f3fa3d4ccfd8af406ec1dd92971a3ac76edc"
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
