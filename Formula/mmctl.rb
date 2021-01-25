class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v5.31.0",
      revision: "fc161b2931110a913169a0601f0d9d0a36b1749a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/mattermost/mmctl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0c01ada6d6a6b8084f10e1fb3b2b735963792333e607cdb8e4a5d0c2871ba82e" => :big_sur
    sha256 "ab8f81ea9e3e3a7433923592b47be7edfceb302dac64b19fc96ee20e3c9c149f" => :arm64_big_sur
    sha256 "ba9befddcab79938e336168f6bfc08dbb9590fb1c0d32425e02f1c4ff8cc0034" => :catalina
    sha256 "dd23fa7b84f2b7f39f19ee60f69fa751f21ee2eb86b4a612603665d9d30810d6" => :mojave
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
    assert_no_match /.*No such file or directory.*/, output
    assert_no_match /.*command not found.*/, output
    assert_match /.*mmctl \[command\].*/, output
  end
end
