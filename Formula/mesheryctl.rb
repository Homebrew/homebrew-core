class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.28",
      revision: "43ed38b83ce9568c4990f039dbe6167a1df14c4e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0570d0b6ca515b53348dc9730b8a605d8dd609c713e2403b29e6ef1d00b53d4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0570d0b6ca515b53348dc9730b8a605d8dd609c713e2403b29e6ef1d00b53d4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0570d0b6ca515b53348dc9730b8a605d8dd609c713e2403b29e6ef1d00b53d4d"
    sha256 cellar: :any_skip_relocation, monterey:       "82e112849d2e3e5c07e33ab8fd79bee9ebc1b492c43f90c58df9c745a28e46f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "82e112849d2e3e5c07e33ab8fd79bee9ebc1b492c43f90c58df9c745a28e46f0"
    sha256 cellar: :any_skip_relocation, catalina:       "82e112849d2e3e5c07e33ab8fd79bee9ebc1b492c43f90c58df9c745a28e46f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0479f122a33b4fb94d5cdf5f0f814284b1481c718890851083fdafa7eac7ff16"
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
