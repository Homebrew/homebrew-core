class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.110",
      revision: "cae16007478003171e14f56639ff6ad1bcffdb10"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85c32e546216acfd54410357b15a19b656d3219c355228194a0e48b551825c02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85c32e546216acfd54410357b15a19b656d3219c355228194a0e48b551825c02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85c32e546216acfd54410357b15a19b656d3219c355228194a0e48b551825c02"
    sha256 cellar: :any_skip_relocation, ventura:        "1e4a1f130262aca94abdef53a61211ce9c61f7072b3d317e9fa8a50d1e75a9d7"
    sha256 cellar: :any_skip_relocation, monterey:       "1e4a1f130262aca94abdef53a61211ce9c61f7072b3d317e9fa8a50d1e75a9d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e4a1f130262aca94abdef53a61211ce9c61f7072b3d317e9fa8a50d1e75a9d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b58185d6ef390c9284fbec8dc6de524653554e842da9d05f0faba1a9753aede6"
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
