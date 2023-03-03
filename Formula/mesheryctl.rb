class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.61",
      revision: "2e3bd59c40f6b3a8f09f980ced5f31089cefdf94"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "201808436d1920ef99ffec78c677cadb5d2017d65049e2a309c8f93937053338"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64dbb5c20cdc888e8f6d892a27a9bab79e19f0c6bf346aaeeb548dab5251db7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "201808436d1920ef99ffec78c677cadb5d2017d65049e2a309c8f93937053338"
    sha256 cellar: :any_skip_relocation, ventura:        "9f7d13fd5457488117ecaabae7d51a4858abc7892a070cf3ce0894a85fe61a06"
    sha256 cellar: :any_skip_relocation, monterey:       "bc8d5507e79414cd474d5095956b52257dab8cb83efd04a460b73ed6555654f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f7d13fd5457488117ecaabae7d51a4858abc7892a070cf3ce0894a85fe61a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2f65192f408662e17b11c5b1e60cf0cdd746ca1b9191261e734e78c2fd31f5b"
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
