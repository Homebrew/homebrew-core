class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.42",
      revision: "9a61588a2cfb1a47a494599337bc1eda01aae90e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74a873c962539a9ba433248e241044cbbc7b1361692fcdbf10b4634fd047a5ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74a873c962539a9ba433248e241044cbbc7b1361692fcdbf10b4634fd047a5ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74a873c962539a9ba433248e241044cbbc7b1361692fcdbf10b4634fd047a5ab"
    sha256 cellar: :any_skip_relocation, ventura:        "9ea70dfeccaa1bbad1070ea4315a233acb7e85d6f498350bbb56929c55fe9fe1"
    sha256 cellar: :any_skip_relocation, monterey:       "9ea70dfeccaa1bbad1070ea4315a233acb7e85d6f498350bbb56929c55fe9fe1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ea70dfeccaa1bbad1070ea4315a233acb7e85d6f498350bbb56929c55fe9fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f14af5f07e19b7a617c923192b005b569f2032080bcacc1eea3bd7a25edddb5"
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
