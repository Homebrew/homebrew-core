class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.11.4.tar.gz"
  sha256 "8420785707859d64d7cabd66bea46e8da7e0ebcd725e3cb311a408058e4cfcce"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ea417458a88b18417cdb12db9233338921cfe281bb4cf7e785547ff5a7b7e6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a462c977cfbce6f0f13aa6bc531ba7ed222109fa02eafff5b30d52b9f178175"
    sha256 cellar: :any_skip_relocation, monterey:       "8a9f8eb90c3e0fb8761b883c6485a6c941865088bcc020a1ea669f5887512289"
    sha256 cellar: :any_skip_relocation, big_sur:        "8938497ab4e0c955ef9c69241f4e5f8ca12054f56d82faf6d00482ab8ffa3257"
    sha256 cellar: :any_skip_relocation, catalina:       "432788fdd0c08f1aacbdcef08ec69856eb6864cae2416c916ae6dc468d0743ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27469671e3f4d7097eed8a1a1a6075b408837a051d2d214e71d7be73823141bf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/keptn/keptn/cli/cmd.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ]

    cd buildpath/"cli" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    system bin/"keptn", "set", "config", "AutomaticVersionCheck", "false"
    system bin/"keptn", "set", "config", "kubeContextCheck", "false"

    assert_match "Keptn CLI version: #{version}", shell_output(bin/"keptn version 2>&1")

    on_macos do
      assert_match "Error: credentials not found in native keychain",
        shell_output(bin/"keptn status 2>&1", 1)
    end

    on_linux do
      assert_match ".keptn/.keptn____keptn: no such file or directory",
        shell_output(bin/"keptn status 2>&1", 1)
    end
  end
end
