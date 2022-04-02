class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.14.1.tar.gz"
  sha256 "8ecf1613cfc7e17afe33056512f8cfe4cf02f5c881b2093bf935454167f40f96"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caf3424e34a54ca803bc6725e00873093f968d73ba02836e4c59e21df0013d1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5d487c013d4386f207741d29791706e5e9d5fc239a32d4f55303587390db029"
    sha256 cellar: :any_skip_relocation, monterey:       "b69cde067d223456ce98b5ac1a7b3a87586d397f88b1e361ac01a31ae755cfc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8b866dd5081f71a0b8f5ce719abc6eff744e8f58bed2ce5dbde678ab9fa1786"
    sha256 cellar: :any_skip_relocation, catalina:       "6958e4fc99a8ad5262135fe66f1f16f96ece20bb7071bcca912e2f19002ddb50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1304376d4da07b99784ae18188e46892fbcaf9dbf67ab8189f9ddfd957f329dd"
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
