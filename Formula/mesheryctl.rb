class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.2",
      revision: "155fccf915641e05058cd9b219c528e09ece5614"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a3e3986f249a5c640c8afaa1fd51d4c37185126ff96731a5db4b418edf09861"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a3e3986f249a5c640c8afaa1fd51d4c37185126ff96731a5db4b418edf09861"
    sha256 cellar: :any_skip_relocation, monterey:       "91c27b51261dd7f7c6b319d94c990b4af41b44f7319c641183ebac06029d14fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "91c27b51261dd7f7c6b319d94c990b4af41b44f7319c641183ebac06029d14fb"
    sha256 cellar: :any_skip_relocation, catalina:       "91c27b51261dd7f7c6b319d94c990b4af41b44f7319c641183ebac06029d14fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "577c72816646529a5f66ff76c378619ffddf30b8249bfc63e9e9541d05d401fa"
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

    output = Utils.safe_popen_read("#{bin}/mesheryctl", "completion", "bash")
    (bash_completion/"mesheryctl").write output

    output = Utils.safe_popen_read("#{bin}/mesheryctl", "completion", "zsh")
    (zsh_completion/"_mesheryctl").write output

    output = Utils.safe_popen_read("#{bin}/mesheryctl", "completion", "fish")
    (fish_completion/"mesheryctl.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
