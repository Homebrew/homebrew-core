class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.13.4.tar.gz"
  sha256 "c60aa30a91e5e10cff44d4416b651ceaa1ad4a4587551363b1ab69b896896f7d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd6820abf45fa2b45485b8254455d51ffe6fa426b677ceb4472c1ecf66623ace"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db3e505dec55394925b0ae67b78974eec98a72801eceac9abed6c3a1d6627bac"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b8bd3f1ea4bcdeec333d3e88d1161950b39121c1d58f8818117c513aeae9d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "992c2eccea7765d897af7117b415ced99482c89b94b825daf4c08b75f169f7d2"
    sha256 cellar: :any_skip_relocation, catalina:       "6b84bfbf4166eda46af3633a2cee3f9f93b1591d2319f46b904a184fa112e0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70339160eca7470d014b2773389d4f7be77210eb6f079a9a18a4fb31f4e8c681"
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
