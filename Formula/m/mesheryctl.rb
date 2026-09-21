class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.70",
      revision: "2f045677aae07c7f651aaefc67be068b476744f0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f50128c367b7392389aeb90454ed632fdd8f89f9023976278220a958c961b037"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8626ef1b330f8d5bd5e1a5169d7962b586a6a06a04466db54c4b3a597ba123f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d365f530b4d5221e75ccd0b740345d6ef4b983e7a034e7bfcf98b21b7fe42ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8705dfdd07249f690419b4aa1b642d6868930f9a0ef67ef9d6b8d844873dc857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ac247a783674df382da17b4327a424d5f73163d05492b051a68df6a617dfcf05"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
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
