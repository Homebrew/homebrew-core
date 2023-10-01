class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.147",
      revision: "8835ffab82902f5c0a436c74bbdf7e54894a79c1"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff5c26607bcf6e6cdfd350c205f2267e817abec53f786fa7b43bd5f04bf94e1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff5c26607bcf6e6cdfd350c205f2267e817abec53f786fa7b43bd5f04bf94e1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff5c26607bcf6e6cdfd350c205f2267e817abec53f786fa7b43bd5f04bf94e1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff5c26607bcf6e6cdfd350c205f2267e817abec53f786fa7b43bd5f04bf94e1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2cdfc9055a79811cdf83392545bc7362a6a7b190f3c74885f6a36e0deae2db5"
    sha256 cellar: :any_skip_relocation, ventura:        "f2cdfc9055a79811cdf83392545bc7362a6a7b190f3c74885f6a36e0deae2db5"
    sha256 cellar: :any_skip_relocation, monterey:       "f2cdfc9055a79811cdf83392545bc7362a6a7b190f3c74885f6a36e0deae2db5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2cdfc9055a79811cdf83392545bc7362a6a7b190f3c74885f6a36e0deae2db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4642868095747c6388c56202e48fdba8864958d7350b12d9a1663542b162637"
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
