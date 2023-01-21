class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.45",
      revision: "57e958d8f5c2b273825c3974fb9a7896ef690c7c"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dd7ee0186a487df38d5b307fb1b6abc204c297b6916c5f0f4e3ba3bc185a6c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dd7ee0186a487df38d5b307fb1b6abc204c297b6916c5f0f4e3ba3bc185a6c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dd7ee0186a487df38d5b307fb1b6abc204c297b6916c5f0f4e3ba3bc185a6c1"
    sha256 cellar: :any_skip_relocation, ventura:        "978b433cded9ef030a5092626bceb91b915cb0ec8aa2c1026f6ad820ca707e24"
    sha256 cellar: :any_skip_relocation, monterey:       "978b433cded9ef030a5092626bceb91b915cb0ec8aa2c1026f6ad820ca707e24"
    sha256 cellar: :any_skip_relocation, big_sur:        "978b433cded9ef030a5092626bceb91b915cb0ec8aa2c1026f6ad820ca707e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "195d0944d7f5d1de0ff6d85c41a5a4bd0ee21b84ffa0ac3a9296e5ddfd4e0c65"
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
