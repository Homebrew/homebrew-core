class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v5.34.0",
      revision: "8a845853a0b9536369caf62e2ff36652602fcb58"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12e1ddd63c242d172d2a60967ce5a0edd5baca55eef783c4e8a3d493f411cf60"
    sha256 cellar: :any_skip_relocation, big_sur:       "f9946f7dc11c3e47e45df2ab7979c1263d035b0cd426a9854df9c0edfe382690"
    sha256 cellar: :any_skip_relocation, catalina:      "29a6b4f4e8b327459de4a218db5ab01c7ef7b3671899915eb05eeda2d45fe100"
    sha256 cellar: :any_skip_relocation, mojave:        "9bc83eac00be3155df463aa9f7219798b14901a7383d6f13be4d9baa343079da"
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
    assert_no_match(/.*No such file or directory.*/, output)
    assert_no_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
