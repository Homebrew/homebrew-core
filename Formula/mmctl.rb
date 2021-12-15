class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v6.2.0",
      revision: "8ab71ce6a5a2ace763da00c58576ebe250b87001"
  license "Apache-2.0"
  revision 1
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61eb2e5d52daaacbd019cfe9763b177de5f042aa98abab2c418749057df54a89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3aa5611657dd22017b3f589c84ef0810c4c28c35c7bbf66ad5c248c2c08d975d"
    sha256 cellar: :any_skip_relocation, monterey:       "53823e82550dce9c2739ae97b7d979349084805f4551366e2db7b808ca90b1a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc5953d261ef48aae7a52819f241b56dd4b855833bae12f31ba936db128b82dd"
    sha256 cellar: :any_skip_relocation, catalina:       "70cac0a9070244d366e5d201198eac95509c5a7db20a9d0dccb1b7f7ca3f2e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a051eea8e58af5424d0d8c97e4d1f64f3f731ae8a41c68411a85ca0caa4e707f"
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
