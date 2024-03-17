class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.33",
      revision: "ad9db94fc3dbdf71503a22ee7aadc9b966985a95"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d03adc87ad249145fa1cc11ae008615b9d7368cfbd3ea8c520132b4642022718"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d03adc87ad249145fa1cc11ae008615b9d7368cfbd3ea8c520132b4642022718"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d03adc87ad249145fa1cc11ae008615b9d7368cfbd3ea8c520132b4642022718"
    sha256 cellar: :any_skip_relocation, sonoma:         "78d307649f9b964785c0a6d7cc218a7de58091405328e36747e3b84bf36b2a19"
    sha256 cellar: :any_skip_relocation, ventura:        "78d307649f9b964785c0a6d7cc218a7de58091405328e36747e3b84bf36b2a19"
    sha256 cellar: :any_skip_relocation, monterey:       "78d307649f9b964785c0a6d7cc218a7de58091405328e36747e3b84bf36b2a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dca509b35d764ae0fb58d11099344dda941f0739334b7dec00ad1fb92e06923c"
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
