class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.0-rc.6fc",
      revision: "aed75e2e53b1bd7ae3437d21e221404f482cf224"
  version "0.6.0-rc.6fc"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dea953ef5dd9c7179a892de460f6fb2a7297d245c97ea1f301b82ff35045043"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dea953ef5dd9c7179a892de460f6fb2a7297d245c97ea1f301b82ff35045043"
    sha256 cellar: :any_skip_relocation, monterey:       "623b5333cf4d52e633dfc31ef5a052cf9ef81d2f64c21dd7c3839e8b683dba93"
    sha256 cellar: :any_skip_relocation, big_sur:        "623b5333cf4d52e633dfc31ef5a052cf9ef81d2f64c21dd7c3839e8b683dba93"
    sha256 cellar: :any_skip_relocation, catalina:       "623b5333cf4d52e633dfc31ef5a052cf9ef81d2f64c21dd7c3839e8b683dba93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c3af99e443a5a7e2564d16c63c14aae895510841843833842679ff373d7451"
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
