class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.81",
      revision: "ba6451b525b971fda79380caa0b295d2d4bf63a4"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84e3478290c09beeb25d254f20f585602501a31107ef0708987c4426b25551ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b4754387868c691431e61bab4144e107e2267a432ebb8b862a5e6c1d68a05aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89d538592086281307dae327bb59573f36396429d0378d33def007d8cfbfe28a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6e99bdf0aeb560e57f294ce45d67b87f4dc50974a405a1796388848d6560a2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ce0eb24f30ffb480077a47c35031d9c5ac72ecf7be1fd865af3caa6b65577ed7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
