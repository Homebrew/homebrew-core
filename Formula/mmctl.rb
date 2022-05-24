class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v6.7.0",
      revision: "144fdb067b1a4923b92420a31da99103ecfc45e6"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d915116220f808e1940d7545075508c429de98b660c1a8dc495c990d4322bf31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26b632edd81841fbaada4434ad3d3f4aaa0ee43e50a4c9736bf4a58ad94fc67f"
    sha256 cellar: :any_skip_relocation, monterey:       "5184a7315ebce60a54e41675bebc30a7ce1c8993b970eb53778d15fde19ec823"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb51f5c41c4c5d0d986ac0065fe583fac732e0b6b05c5678a9f50739bcc030a5"
    sha256 cellar: :any_skip_relocation, catalina:       "54be23acf1dcc34488e475d2c2c7b7ea558ca3a4cdbee7c757bb9b4241c6ff18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f6686bd8844104354fa72bebba0ae8e88021ed11c0d879572e81d88115e3eb0"
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
