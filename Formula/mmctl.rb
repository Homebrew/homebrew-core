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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "536dd0594e19dd46bc34b842955d82c6cbc431ce27b761a178ff974e88da4904"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ac4e14e5a8267768db6a655107c6087ecc5c5a91c662be7394d07698d638650"
    sha256 cellar: :any_skip_relocation, monterey:       "e567eb99f82888e1acdf40f3997ed20bf45129c7dc4d8c6653967af9c307fa56"
    sha256 cellar: :any_skip_relocation, big_sur:        "48aaa034edd491bd69c4d9225f5908749ed671cde2a7e737e122102b74a43442"
    sha256 cellar: :any_skip_relocation, catalina:       "ef9468690951c1f7258a87c66bce7e1cf1f2193b5b1a40545afc4438e38409d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b71c7c78ac00fca3b6b7efa230fe1e63d8c4be637f0e73059d2bdc77dca42d"
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
