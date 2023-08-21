class Keptn < Formula
  desc "CLI for keptn.sh, a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/1.4.1.tar.gz"
  sha256 "c680a8a447c71957fffe242a3f9a88b0c1deb70acca577aad45017f502f58891"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39b893d3a204719d97d653e27bf61140db969aeb5268a0409ba9ad01f391f7dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cb9a0b74309d0c8e3992bde7f620e5cec6fec33883e8a7ee0958560f07501f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9bc4c50958ec1692c29369d2826723a7e41a5c5a0d51c215e07af9109d0aa65"
    sha256 cellar: :any_skip_relocation, ventura:        "7cd5d852c5154f83e8f60f135990f4aa36279f88b9642b87e327a6984e4eba62"
    sha256 cellar: :any_skip_relocation, monterey:       "b9ee7cc7073f6598f280019a757244192d402011ef08b1990dbaf820bf548fb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad51c102f6b70ccc46b6669f5e234bd406d9fc31b359734f7b32d31900e12aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c17f287c76e468b75b5422c9e0b5961224b98e85b01a28cec3bca743bbda9329"
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

    output = shell_output(bin/"keptn status 2>&1", 1)
    if OS.mac?
      assert_match "Error: credentials not found in native keychain", output
    else
      assert_match ".keptn/.keptn____keptn: no such file or directory", output
    end
  end
end
