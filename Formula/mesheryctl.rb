class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.32",
      revision: "497cf660bfe45812e851c34465c60f203c012fa5"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78f630e8a8d62d9cca656f4693e159cdb3412ab96f26561405b0d04ac1d5a52b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78f630e8a8d62d9cca656f4693e159cdb3412ab96f26561405b0d04ac1d5a52b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78f630e8a8d62d9cca656f4693e159cdb3412ab96f26561405b0d04ac1d5a52b"
    sha256 cellar: :any_skip_relocation, ventura:        "95349600810adb20c95b608ec66863f4ff1da24b5d73c5b4d2456971eae39b7e"
    sha256 cellar: :any_skip_relocation, monterey:       "95349600810adb20c95b608ec66863f4ff1da24b5d73c5b4d2456971eae39b7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "95349600810adb20c95b608ec66863f4ff1da24b5d73c5b4d2456971eae39b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79aa02c45eb18a32201710ae2a8f7fba1964c65975583948ab4295a18a0e20e9"
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
