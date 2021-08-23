class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v5.38.0",
      revision: "cf832fbc44c2b36afde8bf1c01ff72f877cea79d"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2100b6ed7798a993f34233c4b6b58759c83ce0f96b3c39a66d192d6a89c3d570"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e14c73707eb41c21ad5b9b6aea1850b56b71b79dd7fa6e8ccd8ec48e888c162"
    sha256 cellar: :any_skip_relocation, catalina:      "9c7223fc02910173dabd773352af3617e92e1cfacc37337e43f5606cfeeef13d"
    sha256 cellar: :any_skip_relocation, mojave:        "4db09ecf5831227464cf41b6bd512e37a079406c124d32ec93b4ce14987772cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b588231aa08d4972a9aed9e0d57d022090dcfb295a2a32a8c17cb766d561ea2"
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
