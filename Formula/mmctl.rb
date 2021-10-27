class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v6.0.0",
      revision: "85dd8887b1205800ba42128ddff58263c1d13925"
  license "Apache-2.0"
  revision 1
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7827a5ec216ac4f1eff57b0ec2f56e28e47d59d725afe3f9a0193187bb25b3a2"
    sha256 cellar: :any_skip_relocation, big_sur:       "6df8f07b3eea0ee889492dbba869f57b2a93a8040a6a6a791411c55a8b28ad33"
    sha256 cellar: :any_skip_relocation, catalina:      "4828e54217a17c41a21d6dfc4eea4a678f20fe093c3ed8e8ebbac2ef4e637c84"
    sha256 cellar: :any_skip_relocation, mojave:        "b13f76c29bf9dc8a87e33345d3e97efd5a7f65a45e69c34d64110db24d023122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2509eed21928303e1e2f49f35cc4f8bfe6ed7f0086a3ffb185fbdd855860f646"
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
