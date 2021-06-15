class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v5.36.0",
      revision: "a3c6ff14a9f44dc847fa629a9e8ab516b8b883ec"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37dd0cbcff879356df7b9c98a2f240d1dbf98ba1ba0120ccc09e02c4d6426dc9"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d49102a68b99a00da3e3889be2f2e2fcad95320d708560f209d3ec0897fb440"
    sha256 cellar: :any_skip_relocation, catalina:      "a66045beaebefb112620b20d9c5e15bb09ae8360b08dd2e8228c3c5db9139e94"
    sha256 cellar: :any_skip_relocation, mojave:        "28dd9de0d2774ae089b267e677194014614453be8bea52fa9e396b2f1b87564c"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath/bin
    ENV["ADVANCED_VET"] = "FALSE"
    ENV["BUILD_HASH"] = Utils.git_head
    ENV["BUILD_VERSION"] = version.to_s
    (buildpath/"src/github.com/mattermost/mmctl").install buildpath.children
    cd "src/github.com/mattermost/mmctl" do
      system "make", "install"

      # Install the zsh and bash completions
      output = Utils.safe_popen_read("#{bin}/mmctl", "completion", "bash")
      (bash_completion/"mmctl").write output
      output = Utils.safe_popen_read("#{bin}/mmctl", "completion", "zsh")
      (zsh_completion/"_mmctl").write output
    end
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
