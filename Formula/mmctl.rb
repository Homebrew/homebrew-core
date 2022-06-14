class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.0.0",
      revision: "da16e02777ba86aceb098fdaeaff393b5a2fe7b7"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "245074ad14e65976afb32c509981231e28983480282f55089808f1f6e0e8d9dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9025f3300f6aea47315cfecd9c277d7fde7a423c6baea714e77ca7243260167d"
    sha256 cellar: :any_skip_relocation, monterey:       "e3218661b573e4c37f943a9818d241ffc2286cfc40ea988dc870074ebb50b47b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac5db3e36d3c4f1367dc4e452969a7fd75f75ee6a876c5bff91bf7a91e7a68cf"
    sha256 cellar: :any_skip_relocation, catalina:       "8c8659e3bb55ebc17f689ffa9a896ce0f8dcc31c4d46fee77216004527a043dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4480d074c3f6f4b174cc3c584316eb0b704303e95c9846a01da1a43d4aca143d"
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
