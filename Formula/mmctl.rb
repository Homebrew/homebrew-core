class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v6.5.0",
      revision: "6dc3715c5ad20b17cc53a2c70be76aa21845c165"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d2ac36ab10fd1d3c64227cc1679256b9d095acf74036e80fd0e94c80606ad9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bab610149c47fafb1e62279993ab111d1648094c0717ea42c361bd35a4f3e9f"
    sha256 cellar: :any_skip_relocation, monterey:       "247cfebfa682f74a8a9f1f2b99d7d287d0e1005625858bfb08f9c3ecb5d254e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e65fb9841d37fe458ba6dc94a94dd540aac8e020be06c7d4d4b7ade5f0c57b1e"
    sha256 cellar: :any_skip_relocation, catalina:       "ba79d921fc5174562b966e9665725239aae83b67e9d357152a412206a413b08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5724ffcb8262100a590c2bdf7a2826f87b7fb2da6a569b005cac29b535fac6d1"
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
