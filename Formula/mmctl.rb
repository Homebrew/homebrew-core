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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2100b6ed7798a993f34233c4b6b58759c83ce0f96b3c39a66d192d6a89c3d570"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e14c73707eb41c21ad5b9b6aea1850b56b71b79dd7fa6e8ccd8ec48e888c162"
    sha256 cellar: :any_skip_relocation, catalina:      "9c7223fc02910173dabd773352af3617e92e1cfacc37337e43f5606cfeeef13d"
    sha256 cellar: :any_skip_relocation, mojave:        "4db09ecf5831227464cf41b6bd512e37a079406c124d32ec93b4ce14987772cd"
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
