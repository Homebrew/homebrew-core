class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.4.0",
      revision: "f10f7f1519dcd82ed0f8f9f00f76ca943ab1f42b"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cd8919d1d9bea74bdc9aa6f19540459d849e6fec980f2a16c02ff78e590771b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6fa4da2dbac4483b870a3c53720302dd71ece3216b197b89a68075a2b20b696"
    sha256 cellar: :any_skip_relocation, monterey:       "f38cb355bca4961778f336c7bec6c7c813ca51e51e7c6d1f8d23191501baa82e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d72e85314cc476381e6707218999aca69cdec319131302e555ac15bd0a774be"
    sha256 cellar: :any_skip_relocation, catalina:       "6df4c3d74363fc08b26f4302b599a6c27fc173dd2911e6be65fc1b6060e16d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06f2851a49537781c511941a0aa6348cf80b9acd005182c2b6e86e2c9602dbb9"
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
