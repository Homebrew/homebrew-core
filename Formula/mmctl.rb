class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.1.1",
      revision: "a60dace71816ac4e38567c1ef766e51cac3b3a20"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1ff4314279be447a43147bea39cda66f57aa1c3ff1d737edf486dfc9d984abd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6e763afa47dcfffecdf65679d3d776e69ef8ab0119245ba4338a6b0fbf67e32"
    sha256 cellar: :any_skip_relocation, monterey:       "b022dfd93727de0d070264f8ea549037b03a1fabf4f0039af8f37cc6e91ecc62"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce8e2297a9403f7c192596a1bd547867f205f9b407ebd1e6b3a93f563b770d9a"
    sha256 cellar: :any_skip_relocation, catalina:       "40b5e4efe9b7255566f3472761d4c568148723491c26a96a380b040ac87786a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b502b1043321a581a90513120da7654e82b76ebddcdfbc259181d713416baf49"
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
