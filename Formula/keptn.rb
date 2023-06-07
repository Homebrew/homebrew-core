class Keptn < Formula
  desc "CLI for keptn.sh, a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/1.4.0.tar.gz"
  sha256 "8bc226cac50ca3a42918f6c8cb60747d7adb94efd79ece660d2327cd05077838"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ab5c1018700e0e4c6aeca75d32673d7852fe34f1bf352d4fd800ca546db1094"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4a52bacd3dbf542f5c0024a78edcb8176bafcd934e1f4ebbb65e52746c38728"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "329eff36cfe2198ae3ed73193ea52d80f952f7556c244e4d0b2d9ed649082444"
    sha256 cellar: :any_skip_relocation, ventura:        "4ba0c36e86a110f51b86c0699bf94ece7f505d0d65b399fc7d49fc0c65512537"
    sha256 cellar: :any_skip_relocation, monterey:       "16d91fa3bcbbd748d1e5706b8f67fb12bc404ec4d822966f0bf22cd7833b9d3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b12fc15f9cc619c2eeeb3d6eb57d9881a63e141b1febaa24819dedb3dd6d9004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "812fbc2eda7d3547dc5e618bc5c92b0c2ceb958c736d41e6c153fff5fe67953e"
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
