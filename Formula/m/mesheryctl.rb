class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.68",
      revision: "018bd3bbb40494464af89ebb8a157044dcef9a01"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bbd4ace98fccc371eef43ec9f2375b2b5b4087a7e9fff8a8def624cf3299d0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "010713a8c4c9c6b63e957c30c53f04940f34e9a737d1154402f2190d47fa5157"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b31e0a7f88e201c98b8542c54bcba1c4137a77f7bf3670b2f932b8fd35410bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbd6c5852cdeb0b9d4a5bfbd2fd4ec6492c7a25d772f2e5af875e7f571a4dbbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d74230bf06473b8392e2f626dfeb7ac8d0f8127e23997b8ead052ea98662a34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1e5d8b2bf4b858b71be2a06148cb856ddeb6dbd474852cfa9650113945d18b7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
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
