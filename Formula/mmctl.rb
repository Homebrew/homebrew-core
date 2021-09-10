class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v5.39.1",
      revision: "bdc509d9aae4e95a2f89246362ec6538dd441934"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e1a34f03bd5697b4a57dd21d63c39a2944422b7bb67d9ffa0d040016c1ba6a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "a367c4733881611ab5d65d9bb60c20359163b2a329f9623af46deb90fe98b9fc"
    sha256 cellar: :any_skip_relocation, catalina:      "cdf7292bcba0fab6c616ea127a7e16c4cba5619fd0fa519dd190d14472f2b035"
    sha256 cellar: :any_skip_relocation, mojave:        "090a84295d28ea87de18093a8b2deea1313e5e52897a61e6c5ba6574b8b7310f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6306f1bf77de1213f7cc172ca816016cfe730ff6b6c9d7642b4b5222d2e9c315"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

    # Install shell completions
    output = Utils.safe_popen_read(bin/"mmctl", "completion", "bash")
    (bash_completion/"mmctl").write output
    output = Utils.safe_popen_read(bin/"mmctl", "completion", "zsh")
    (zsh_completion/"_mmctl").write output
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
