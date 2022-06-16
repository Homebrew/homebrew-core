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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fbdbb94d90df3c22c16a4d01a082bb5d1b13346089e1d71e622fd1812f57bdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee41e0354f4245055efbd4556bc223e69910257f55bbd1112d59f732e29c8e31"
    sha256 cellar: :any_skip_relocation, monterey:       "51017fbb6bea024e4068a89ccc782ddfd9805abca2bbdf476ce4c782a15ea72f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1b8e9a24364b1df1828d3017526bfc3ac012dcb1f5aefc48148a710cddf38be"
    sha256 cellar: :any_skip_relocation, catalina:       "ebaeec5f629dedb33c81209350419953881150c04c2883fdb7b9bafd64f25f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183559236cfb696b702edc92e1a659e5e21e3d26e4e8da23810104578f636a49"
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
