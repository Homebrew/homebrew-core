class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.29",
      revision: "c71a0ba7d39ceaad12e69457f9ac9de5bbc344d0"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9a8173b3b5174f3bd58158f7f3d6ccfa31da066a26c231864bb4dcf9b93d635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9a8173b3b5174f3bd58158f7f3d6ccfa31da066a26c231864bb4dcf9b93d635"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9a8173b3b5174f3bd58158f7f3d6ccfa31da066a26c231864bb4dcf9b93d635"
    sha256 cellar: :any_skip_relocation, ventura:        "08ccb711ef4df51e54b72dc260016ff8cf9a57a9fd440485828e75cbbe18de6a"
    sha256 cellar: :any_skip_relocation, monterey:       "08ccb711ef4df51e54b72dc260016ff8cf9a57a9fd440485828e75cbbe18de6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "08ccb711ef4df51e54b72dc260016ff8cf9a57a9fd440485828e75cbbe18de6a"
    sha256 cellar: :any_skip_relocation, catalina:       "08ccb711ef4df51e54b72dc260016ff8cf9a57a9fd440485828e75cbbe18de6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62bc9173705061fc51d83a0b724cd1191e194f99fc3bf5612e29093793a07126"
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
