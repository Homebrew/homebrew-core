class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.39",
      revision: "0ca1b39119c725844429d06a3deed09958597633"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e033b8337fb75bc63b3308a82e78a6cd53268db0f8f8bc0e45f52f9b25b2af7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e033b8337fb75bc63b3308a82e78a6cd53268db0f8f8bc0e45f52f9b25b2af7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e033b8337fb75bc63b3308a82e78a6cd53268db0f8f8bc0e45f52f9b25b2af7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9fe9315f8ad1bf8405f0f8bc0e9b796a833ce7223cf9c8ed01f1d87b88f57c7"
    sha256 cellar: :any_skip_relocation, ventura:        "c9fe9315f8ad1bf8405f0f8bc0e9b796a833ce7223cf9c8ed01f1d87b88f57c7"
    sha256 cellar: :any_skip_relocation, monterey:       "c9fe9315f8ad1bf8405f0f8bc0e9b796a833ce7223cf9c8ed01f1d87b88f57c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78d571b4a81de370cdff23b67b056bf5efce641e1aff0dcbcded6275671620ec"
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
