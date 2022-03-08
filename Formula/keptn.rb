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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9feabface8b6228d1b0292f72178c6cf0f37b0464f9fa116c5258021094996d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "404a4c679ca7bb928135e7cefa658f32609ff5a879bdb4d330f9dc3d5cc05afd"
    sha256 cellar: :any_skip_relocation, monterey:       "772d03843c5cbb5335e43f9de9bf79197042f67d4feade801664398d4f8c7b0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "883d74bc452e155c74b59a1e73c171eb43d79dbff637f271fb7e70b53bb23af7"
    sha256 cellar: :any_skip_relocation, catalina:       "a1c9b4bbf0a9047bc4a6867dcd1af31d93518de8bbc5a2b83c0f12de7ed27004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4d0cd72451139595ac79f0c825631940db46f530e05e1bb8092f017a584527d"
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
