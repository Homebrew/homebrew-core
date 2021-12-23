class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.11.4.tar.gz"
  sha256 "8420785707859d64d7cabd66bea46e8da7e0ebcd725e3cb311a408058e4cfcce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb234499511e6048462a93fd4453b76c86a60be85f0957be4a2c0216eded0287"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad3ceb5b6ddb946a8f4e3ab1130940cc0efe0ced3b0a4bcb32dfd091191b4aa0"
    sha256 cellar: :any_skip_relocation, monterey:       "133844c9739c9cdcf50c7f961e609a9d832c99fd256f7ca4ab694dafd203731d"
    sha256 cellar: :any_skip_relocation, big_sur:        "58e6374628559934ee6ddef4ab4b4048b20796c49c9995750872069c35174232"
    sha256 cellar: :any_skip_relocation, catalina:       "543d1e51e82aa9b1c08a2fd38e2e9a9bed29636968960e9547d2894dae048923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b99b7b86361c2eeb120f6df246b789a7f13c51fcac6d8425dcc0724039a464c5"
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
