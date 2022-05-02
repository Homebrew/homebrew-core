class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v6.6.1",
      revision: "7b4623c434caf6fe9f315e8cedec3dd4f8e082fe"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41ac51481c24b3f33b047f00386941bb2d40b5d8ff4c67dd65fdf32bbc7db604"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbfbb9cd41ea4ebce0f26c695bf21b94d1dc1e2ceb27586beb9efaa82ba07627"
    sha256 cellar: :any_skip_relocation, monterey:       "1a2cacdf9f8c5209a0f15d3939a0e1c6efe7ba0a679943ea9924de87e0cfce0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "239bf30a1d98e0fd5122412c8904aeef78adffd105da25283a5d86c235f6d37d"
    sha256 cellar: :any_skip_relocation, catalina:       "287bd574b6b43a82762fcda0e7587931e32756f5dabb816c24e8d432d92e8daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f68243961f5997292a997859a3dde35c210ade48d0bbefffb73304a0026c2bb8"
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
