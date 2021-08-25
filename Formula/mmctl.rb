class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v5.38.1",
      revision: "7e687f43db44f181732afeda8f3ead7d4b326f4a"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8dbc58b892467e7993e7eb0fd8057f422c275ebb48a1a580030dd6b7002f4275"
    sha256 cellar: :any_skip_relocation, big_sur:       "fee7f54d8736deb5f5e551c9560f36c292b464f654f80861d33c5596dd386d17"
    sha256 cellar: :any_skip_relocation, catalina:      "edaa5058df6a486136dd8115487a0ae530a1394a06cb87442015947d0fe1fd37"
    sha256 cellar: :any_skip_relocation, mojave:        "373a36850a48177e87bd953aa16f47e880341a5f1b86afa83dca1eacd31461ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a82a77c0918609a1f24c1fb1a7f6994ba86e3ddefa043550a0fdd34b4fc85905"
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
