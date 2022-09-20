class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.8",
      revision: "931b5bbee492e7139b75a5f806facb7bfcdb6e50"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ccaecaa1aa557635138ae5e59fb89ebb80c167a86c9a14fe95ac3194811db41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ccaecaa1aa557635138ae5e59fb89ebb80c167a86c9a14fe95ac3194811db41"
    sha256 cellar: :any_skip_relocation, monterey:       "5c3dc35c9f3580c722d97512a156a9209eb0fdfa635bb033a0b4bd117d861675"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c3dc35c9f3580c722d97512a156a9209eb0fdfa635bb033a0b4bd117d861675"
    sha256 cellar: :any_skip_relocation, catalina:       "5c3dc35c9f3580c722d97512a156a9209eb0fdfa635bb033a0b4bd117d861675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bcb4687e3251e7f99bb59a77efaa980618a5400201156aa9476a3a448e66310"
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
