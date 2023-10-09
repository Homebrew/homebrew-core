class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.155",
      revision: "1b5d78ed34648e0a91df8c2273026b930f748fbc"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a12975002260cd5a91eca99f95bf76124698f602ccd10cd0608bbcdaf5c24b3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a12975002260cd5a91eca99f95bf76124698f602ccd10cd0608bbcdaf5c24b3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a12975002260cd5a91eca99f95bf76124698f602ccd10cd0608bbcdaf5c24b3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d9161e57143a5c9ea2ef2600d924cba89cda0a4f48152da7fb86e1d49815245"
    sha256 cellar: :any_skip_relocation, ventura:        "7d9161e57143a5c9ea2ef2600d924cba89cda0a4f48152da7fb86e1d49815245"
    sha256 cellar: :any_skip_relocation, monterey:       "7d9161e57143a5c9ea2ef2600d924cba89cda0a4f48152da7fb86e1d49815245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1581d2feafd9d9553ddb0ce7fc7c75689218fca3d59a711d0e4e7da053a04367"
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
