class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.134",
      revision: "05aead396fbc2603bcc2223d22fc3d4b6a8ce2ec"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50efb05c4665273e721db974b6c389dfc52bbffa486689fd77dba2efb1b69f8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50efb05c4665273e721db974b6c389dfc52bbffa486689fd77dba2efb1b69f8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50efb05c4665273e721db974b6c389dfc52bbffa486689fd77dba2efb1b69f8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "348e2009d375b41bd131ab9264f8fe0b2a225cae750db42565355a38863b323d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fba3f5f92841f1904a77b4573d9ba89ce5cd8c8a6dc38f0d6c44b52f0a406333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b1c3f1b1197905a058c436b43de932ed81bf70f64b26793752758e8284520c3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
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
