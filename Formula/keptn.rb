class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.13.0.tar.gz"
  sha256 "f26eb9ad2147c9caaadb2ab0d0dcab84f25c933b2d1e07679b3e3375d4cb88b2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b79bd714d66d63a5de6610b0969d614ea26cf70dad33e0d0905657c4ca3916fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7341f1ff64ab8c9db1f5d38f629fb5e843f8eca7541a96dea5bb7a70afa20cd2"
    sha256 cellar: :any_skip_relocation, monterey:       "dbd2a49e0532220643a1ef05b31acc08801d1629217923ab455ec0321cbef7d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "113bd14c04529ef452ffc67b52bcab2bb77e202514f3c8500fad55c483d5649e"
    sha256 cellar: :any_skip_relocation, catalina:       "88eb7a6e8b748535f5498b7ec988fe2cc0ea63508b59c875be1ed22c74051e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf926cc2f72a3c26109ffef0c96ca515b1f4f3e30b6301817a3f079a1b85c26d"
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
