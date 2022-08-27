class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.18.2.tar.gz"
  sha256 "806b74f1478922b80a184608c1b8e6a52e5c72f064443d10306fde4b5c3d3a60"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ff5b60ea4cdbb37bd5ce3dcca3b0aa28cb1eba84d6a0ae887aea66d5d480dfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f86bb870eb91813288e4a32ab3f925da748232509fa6f35d90e273dafb83e20d"
    sha256 cellar: :any_skip_relocation, monterey:       "d83d55cc2ae6c1b31880789e13d885a38ba0a72a51d488ef87a8ab1a9847237b"
    sha256 cellar: :any_skip_relocation, big_sur:        "54087fb0d24d1645ffce0b061230cb78baffe16eba0a30288a8c60f97ede45f3"
    sha256 cellar: :any_skip_relocation, catalina:       "f1e3b0da86f3d6a2dd684f598d1183d29b2a238511d3ab8f9d8f3f80bcc67f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b729779c06f724919dd9957e3752a419a419fda0f20a443685392bbb6993a8bb"
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
