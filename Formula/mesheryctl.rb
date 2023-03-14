class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.64",
      revision: "35b66b68c03300715f6ea20e1c89ec8376731deb"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afa3a6b705b20f2be0c3298f61bbdf92e1c89949bdd2dbed51d1d2ca39d58276"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25dd44992fa5842cafc2b9fea59a24b32aa8ed5244d07f1daacbfb6c9acd21a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afa3a6b705b20f2be0c3298f61bbdf92e1c89949bdd2dbed51d1d2ca39d58276"
    sha256 cellar: :any_skip_relocation, ventura:        "c5db0d2a4c1003bb642ed43e445eebffdfdb77d73ccec98d4251143e1cd42e7f"
    sha256 cellar: :any_skip_relocation, monterey:       "f247938a3bf32f451cca535130651c7c26bcbe67e4192211fe5b1537d847831a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f247938a3bf32f451cca535130651c7c26bcbe67e4192211fe5b1537d847831a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae04709592fdb81d056419dc1ac5ab10a7b4b94e0c6c396891dff3895443da55"
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
