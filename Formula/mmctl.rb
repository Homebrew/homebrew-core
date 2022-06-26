class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.0.1",
      revision: "62266d165f180f6ab158026ff4931e1ba7138483"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63f385864ee453c3f5808c836b095129e18066b1e400465a6a7a772e85ff8793"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ca0a0b2dcddb427e4a5ed76bb8c6ae7ee81e00844b685d558b2e1398c34e0b3"
    sha256 cellar: :any_skip_relocation, monterey:       "b6491758d0de6ac44e95d6cfa380284cee91884a21a5da13df36bec3e0bc119c"
    sha256 cellar: :any_skip_relocation, big_sur:        "069150e8c82e89452b2d1f8554806205f136412c584f92686ef2e8ce7556307d"
    sha256 cellar: :any_skip_relocation, catalina:       "48cc7b41e474554758c6f0a79a72d333cb52d6aa6c31b6b5f3afcdca113b2841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eece21a9ae57960c948a49f5ac0df8db1548893f4a7b11394ef8935c59bd21df"
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
