class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.134",
      revision: "7d8385add79cea5a159c5898bdacee0e8339225d"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "619a6950561babde4b5146047b64c6b05ab54a2193d166386cb28988538e1ef4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "619a6950561babde4b5146047b64c6b05ab54a2193d166386cb28988538e1ef4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "619a6950561babde4b5146047b64c6b05ab54a2193d166386cb28988538e1ef4"
    sha256 cellar: :any_skip_relocation, ventura:        "d6207e5d79fddb27e0a1e92326e2a23bda06547095926c51373b389bda4601a4"
    sha256 cellar: :any_skip_relocation, monterey:       "d6207e5d79fddb27e0a1e92326e2a23bda06547095926c51373b389bda4601a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6207e5d79fddb27e0a1e92326e2a23bda06547095926c51373b389bda4601a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0aae31522bc1ff15bb869cc6aa036e603b3f24d445453eee5caa093f4e4067f"
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
