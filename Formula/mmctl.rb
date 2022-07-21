class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.1.2",
      revision: "a60dace71816ac4e38567c1ef766e51cac3b3a20"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d55653adce5276efcc1297a2d7f14d4f6e531e81e75b49cf1fa94b34ba1b80c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc719f76a1c9fc2e7838a6d8748fff6a486cc4acdd29755d94b66f5bc957ef87"
    sha256 cellar: :any_skip_relocation, monterey:       "3492320118a35a8fe305435b207a90df7d3423607e213ef8bc45ffacd16fd8a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "10f92ef91c574bf7efc6ed49c7b017b589e1a476645ccf0b3f83eb7139c86933"
    sha256 cellar: :any_skip_relocation, catalina:       "9d8a10410d001f449e28d5b45ee371ee380205b5bae2fe41efcd6438b2030f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b47d8f454232f91c69416277989d0a5c348050a71dc2cda9e07a4d56048f7874"
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
