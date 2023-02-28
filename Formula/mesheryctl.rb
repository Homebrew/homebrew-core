class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.58",
      revision: "490d9b9b99bae2a2c3118dcff1e2a78df3823819"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dcc020f9b4673bffba7b9c2c25be6198f5a291240f0f32cb5e017c063edbd10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb8fa68f84f513aac6d4297af2a70028fd56b96ce7c570b3e0cb6adc8fdc826a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dcc020f9b4673bffba7b9c2c25be6198f5a291240f0f32cb5e017c063edbd10"
    sha256 cellar: :any_skip_relocation, ventura:        "5ca197c5d5027a8ed4faa9f39b738a7d3c623dff2221daa712a338cffbeba8f0"
    sha256 cellar: :any_skip_relocation, monterey:       "fcb003254450b6bff678d9ef0d8fe24d8f6083b9db79b42abc9e819afb563a7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ca197c5d5027a8ed4faa9f39b738a7d3c623dff2221daa712a338cffbeba8f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfc63831376cf1b1cdbd403f198a092d2df6f87b646d77534e042d306f1cab78"
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
