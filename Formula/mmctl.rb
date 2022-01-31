class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v6.3.0",
      revision: "366110760801667b5bee2764569dbb2566210737"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b85098c39ffc7711cf3b6eae8cc4940a19dcaa201a006803de612948fddbc4d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e5ba9007e8420e7a9f50aeff9eeaa0702573f75bd526bc4facbe616442528a0"
    sha256 cellar: :any_skip_relocation, monterey:       "c2a528ff65ec37182a6ed9290e10edb63a075d6bdd26711bfb31087e783cbe9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "acaba962be6e5bc141adaf64f8cd3bea1873baad82691f926f8eae7a3bafcad8"
    sha256 cellar: :any_skip_relocation, catalina:       "f9aba778619149f792c0225cb98c7f1a7207fd2fb891771b816e5f2ac2598fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d217f0960cfcb53bea648d0ba9c836eb312b426598b32d79f947486edf246a6"
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
