class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.10.2",
      revision: "86d51205b024ee6c29a2e5f8aabe6aa4ab54991b"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b19dfef41236f703e99bc34b0758b49fb0915127613c1b81370cf5b8abbe7f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b19dfef41236f703e99bc34b0758b49fb0915127613c1b81370cf5b8abbe7f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b19dfef41236f703e99bc34b0758b49fb0915127613c1b81370cf5b8abbe7f0"
    sha256 cellar: :any_skip_relocation, ventura:        "b040f7a3a67548d74c2de9d67d47c1b715673127af045300d0fdd59c89ed0b55"
    sha256 cellar: :any_skip_relocation, monterey:       "b040f7a3a67548d74c2de9d67d47c1b715673127af045300d0fdd59c89ed0b55"
    sha256 cellar: :any_skip_relocation, big_sur:        "b040f7a3a67548d74c2de9d67d47c1b715673127af045300d0fdd59c89ed0b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "279507b73aee0bbbcf41bf03d41db4323310c0a3800ef425d901649ac652f466"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
