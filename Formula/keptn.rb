class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.12.1.tar.gz"
  sha256 "57f6c41255550ff7002a95901f01059ad34962c33c0a04696b862c7d303f14ee"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ed3b6528c9d6f76fcc8c4843625959a095b7e2b411a9571ce9b9d96d87ac01c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e34065881e2f8228aa9557b0430f3ba721c93eafd182bc61fde689a775ab9856"
    sha256 cellar: :any_skip_relocation, monterey:       "edecc06ebb5fab67162574047db75f0b3bc8e99053bfe6be1f2c2b0ece7d40c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ba5892f0e2da03b4b1564e06b289bc4a26a46a5f3e09cf2091560f5fd3b1e24"
    sha256 cellar: :any_skip_relocation, catalina:       "254f8535f57b629d5c06c33d62f63b5ed76ec8c9e4b2ac6268d11c882f129608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26f430ef37612b22e28be1b31605e72072724c41cbcb5af839b1a8d78e7afee9"
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
