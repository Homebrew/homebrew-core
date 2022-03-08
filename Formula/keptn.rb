class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.13.2.tar.gz"
  sha256 "214f985bfe3623bbfb7ebc4648f4605fb915cbe75ad9539c8650b1236fcf4900"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7523404e623dcca581b1d94bd10ce92db24c741dbea3bf218d73d71b7b18e61c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5823fe079d5e366acc8320e855c253e0f78ff1b545208756699532fd8735b736"
    sha256 cellar: :any_skip_relocation, monterey:       "0b15128ea6a3578b88e81c6d4fe4d4a859c9c995b9263f10fd095d26b0b95b17"
    sha256 cellar: :any_skip_relocation, big_sur:        "39b8183b223daa8c8f8a2359c01f66876bed84696fca5b15188f0bafcc1400f8"
    sha256 cellar: :any_skip_relocation, catalina:       "0ae35701098fe0ac768847413f14bb69e468dbf11c79d35f1c853723419baedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cab39fcc3c4de0ac4093ab41d810ca961ff66d45af218c7189b39a9d61047af"
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
