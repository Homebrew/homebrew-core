class Keptn < Formula
  desc "CLI for keptn.sh, a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.19.3.tar.gz"
  sha256 "abe29dc9eac9492be9d3836f54335081c84a572ca5ea77d14cca5d062080c963"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9c8f6e3f6cdde2bd624bdb10c51c7c955e26e2a0aebd709a712d9e04fb596bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "514dedeabb3f2a94d55b737b77dc34b8b0a77964617c699d7e6df4ae55af929d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79eb1fb8b8fa079899340e907537d81a41e77999aad57500e677f6f284ce8de5"
    sha256 cellar: :any_skip_relocation, monterey:       "0fd496e28cb0a9a24edab4cbbf507c6d84bf999436e4641cbf03a70721731c95"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b504aa5f7f245a5cfb077585301bfdcb8d2e1ab9f57e2446b714ecf7b46ef70"
    sha256 cellar: :any_skip_relocation, catalina:       "5bb22a70ccbb1d93b0b6c2841633db2e26c83c7e2f2d0119568edbac076de817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3871417c19b0909787fa03c90945917b8a5d715a25183fbc60b879ed1c66703"
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
