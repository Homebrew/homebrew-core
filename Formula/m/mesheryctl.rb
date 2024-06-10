class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.72",
      revision: "7b84c8b4c10c07e17610ca79d362010120e4ab45"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f7a41d7a0f330d062b1d502f3103de0a82b7b561093076347eb3d55ab2b1d01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f7a41d7a0f330d062b1d502f3103de0a82b7b561093076347eb3d55ab2b1d01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f7a41d7a0f330d062b1d502f3103de0a82b7b561093076347eb3d55ab2b1d01"
    sha256 cellar: :any_skip_relocation, sonoma:         "a79485c0ba35730688c51bfb5740b4a4986da30197e80e146dcabe24c4a9b2b9"
    sha256 cellar: :any_skip_relocation, ventura:        "a79485c0ba35730688c51bfb5740b4a4986da30197e80e146dcabe24c4a9b2b9"
    sha256 cellar: :any_skip_relocation, monterey:       "a79485c0ba35730688c51bfb5740b4a4986da30197e80e146dcabe24c4a9b2b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff04e2ba43efd378e88447c6a66f7bd29c7cf7da5f972b29d551839fed3cd9f5"
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
