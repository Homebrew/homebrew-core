class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.68",
      revision: "d0152bb81b72522bdd6e8e6ae65d9153676c6840"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7741a264cd4b95cdf88a2f74a1d53f23bbdf6f8556ce71159e739cc2f2c744a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7741a264cd4b95cdf88a2f74a1d53f23bbdf6f8556ce71159e739cc2f2c744a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7741a264cd4b95cdf88a2f74a1d53f23bbdf6f8556ce71159e739cc2f2c744a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4ab3a1b8f7462a8b9c939b9b99b3fb0c79c17f758a8076e5162edd2234b0930"
    sha256 cellar: :any_skip_relocation, ventura:        "c4ab3a1b8f7462a8b9c939b9b99b3fb0c79c17f758a8076e5162edd2234b0930"
    sha256 cellar: :any_skip_relocation, monterey:       "c4ab3a1b8f7462a8b9c939b9b99b3fb0c79c17f758a8076e5162edd2234b0930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7196fd42d14b6c3689cf711fdf98eaefee4b6eb87b7b3be77f97bfdb91253ea6"
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
