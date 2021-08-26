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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c85c757e0df9d3a180605e9262aef2896db4b5a3ffc4cce9cbfbd95a906799e"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0ad8f11f6f1d236f4bc8d10062b9ddf05d72f36b82111c7ce2f7d7fe042574b"
    sha256 cellar: :any_skip_relocation, catalina:      "b8c46edf05876e42a6ab6d110de040e77682cec85c96ab1b24c4a9b9522102b5"
    sha256 cellar: :any_skip_relocation, mojave:        "586fc92ce3af411131e2b33d513db57a1872ac3cc7e0d0082114bc374b2264c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e311682b18dca6be5403b76cd38447b2510c2edb36cd949298157e1c7c7831"
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
