class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v5.32.0",
      revision: "48cfd91701859a4e59ea2b01b48e0a62ab083c27"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7168739f261a600ff2014c1842e8453bf82c9a3d5c5a0a5973473157a627d223"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b254d989f1d22fd8682e4823a40dd3029961108f3336a331d06407450484e43"
    sha256 cellar: :any_skip_relocation, catalina:      "e54088a99646a73107a9636d23bdfceec98eaf1ea65f6252e0ca034d90c4735a"
    sha256 cellar: :any_skip_relocation, mojave:        "a2b7f4996311ae681a133129c582d40e07b93dda66959e064cac3e9c87e94690"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath/bin
    ENV["ADVANCED_VET"] = "FALSE"
    ENV["BUILD_HASH"] = Utils.git_head
    ENV["BUILD_VERSION"] = version.to_s
    (buildpath/"src/github.com/mattermost/mmctl").install buildpath.children
    cd "src/github.com/mattermost/mmctl" do
      system "make", "install"

      # Install the zsh and bash completions
      output = Utils.safe_popen_read("#{bin}/mmctl", "completion", "bash")
      (bash_completion/"mmctl").write output
      output = Utils.safe_popen_read("#{bin}/mmctl", "completion", "zsh")
      (zsh_completion/"_mmctl").write output
    end
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    assert_no_match /.*No such file or directory.*/, output
    assert_no_match /.*command not found.*/, output
    assert_match /.*mmctl \[command\].*/, output
  end
end
