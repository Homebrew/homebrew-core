class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.19.1.tar.gz"
  sha256 "3ac4838db75f524305d209f7d0fc331e60edb1b8865bb3a7a7f8c1832da4147d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5328db7ab91987ca43f31a5071f52952e2b0993e6e8dfa466d516e6f9f81993c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "878df0741658f1bb600b70e34f3abc287632f7ec7e67a8e726e2b9319cf1a99f"
    sha256 cellar: :any_skip_relocation, monterey:       "fd663c0c9c638a94cbeb1fdc2e7220fdc8db8ff4808e65681f033fce2a06065a"
    sha256 cellar: :any_skip_relocation, big_sur:        "df24d20de9c1c441a0c723b5d1955fe9879c894173a9d63f51f05787503c3bc2"
    sha256 cellar: :any_skip_relocation, catalina:       "04ae57a9f5a8401228813114486ffad5d430df699085c9a4af8774fc3c9bc455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0a7f6392ea70fca13ba5965bf24096786f56358e656941db513d2e578082dd8"
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
