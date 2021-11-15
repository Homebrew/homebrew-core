class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v6.1.0",
      revision: "2097bbf9996308534db3a77e79d7600252066476"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6bf894872872c70af9f8a65ee1d9d2ab1c45ef2ab26b22057a40cda5bb2b3df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63b3c764ba7c57d75b5ef142b75f266aeeb7a4b1f372b16f06579e0fd13cca9f"
    sha256 cellar: :any_skip_relocation, monterey:       "3dced8034513a782ec50a239c4e02f115cebdf2577a10d8549b256236abaf66f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1b297a593c96dd42f75e03396fd24293e6ba77067851560f3fa21ab700f1014"
    sha256 cellar: :any_skip_relocation, catalina:       "6b8e26f417984114729de87ad39fd8c2e156d8e28ed36739d1497e91985fc565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ec9ca96cd33f6e58310458b02dfeb038ee9facffbacb2db75a03ba419ddb628"
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
