class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v6.4.2",
      revision: "b16bfe5977aef9c715cd931dc963c8a7b811debe"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfb6a19df676636d5680e010618f5b587ae99a5ec1586e4d96aaf3303698c3d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "662eeac5eea909fdd1f3d22677b5fe5b670ddec214645e78ab9c2b8a4e7320df"
    sha256 cellar: :any_skip_relocation, monterey:       "d22b6f26fa5746e77bf9e119206b66e4ef5603e55c482e355ea531f066115143"
    sha256 cellar: :any_skip_relocation, big_sur:        "54b8d762b967944d2d5a52f6f6452cda14991f46062e241cae168413b43bcdbe"
    sha256 cellar: :any_skip_relocation, catalina:       "42fc22365fc99b1052a345b4a1af6a358cbdf73ca15e5b5f1c287dcdd2bbf957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "133ae113e091f2e29a8629e701c36a6222b9d8436374492635732828d81c9801"
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
