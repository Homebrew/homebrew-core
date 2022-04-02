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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4b4daeee0060d6890ee50a0d05f86e308568e14ef6a5afd6c8e93a4782e90c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3ec7c692f95e5cbba6aebb955ebb4e7e58c0e0ec4195e4bf09d50a25138a97d"
    sha256 cellar: :any_skip_relocation, monterey:       "a990bab9bb75b88b3f957c9fbc3f18dfd74336435d220f299b195818e5fdf222"
    sha256 cellar: :any_skip_relocation, big_sur:        "03e0096271625e992abbe2357a83717eab4efc47b9437ed1fccb16744be1c13d"
    sha256 cellar: :any_skip_relocation, catalina:       "d0b16fa413048d69d1d26badea960678fd9163fd16f51e09eae36cf3fe8aa64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50132e9e74006ebc3ae12d5bd1c5e8e682a6464d2dcbf1b9dddcae37a333e93e"
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
