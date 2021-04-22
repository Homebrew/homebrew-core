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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8f5064e4a351d73f9c39e4212eb572a3494e0007f7a090c41b6e29c172c4bea5"
    sha256 cellar: :any_skip_relocation, big_sur:       "82f7363723083cef6467caf79263513f8d18538747e6de925c91e3181853a55a"
    sha256 cellar: :any_skip_relocation, catalina:      "ab27c7693893647e0ba7bf409d4b9802f8d5721ac28c20542aede98a283b16e0"
    sha256 cellar: :any_skip_relocation, mojave:        "ac0777f72eeaf8e48dc2f76b111df4745f9155f7f038d937aca43f89c69609ef"
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
