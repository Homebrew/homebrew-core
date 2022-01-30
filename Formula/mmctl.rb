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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1194acb3c5be0384b5cb1c2e0cbf37ccd2efaed98d0b4720b4baadd70bfae8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "accec2d33981741829462cab55fdd5b32de83fba784cdb79ef5ea0581836c223"
    sha256 cellar: :any_skip_relocation, monterey:       "f16b981809cb5f2c7ab06b9727cb8790cc427747c6df0714583a53b4cf6d9aae"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f0866a67a2229164629ca8cf8e790d5e3810e4d05cd9efbc8969827758bbe3a"
    sha256 cellar: :any_skip_relocation, catalina:       "6c9bb75ead7ed7bb117d89eca0af51c9144a466159514d383e8811d3b606beb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "878436336bbfb975e136e5d280742b549fdec6130cf86bb5e2d7c39688453812"
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
