class Keptn < Formula
  desc "CLI for keptn.sh, a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/1.2.0.tar.gz"
  sha256 "a9c53aaf753d91a3776abb3f0a80822ccef27c14fc620b56f9906509ba392d48"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05e9d425f0f35f03318b84c659c6f2ee574d74dcd744011d58d7665272e64d02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9ed0dd83d29fd33ee98f2d7be1178b47e48671712ae7f08b9ae7120462f9d81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26a5353b1c8b34c3963a60a241033a09bfee7b0147e1ba6dbadbb0054687dbb7"
    sha256 cellar: :any_skip_relocation, ventura:        "c6a427ab2b8e70f33194b416fbb28c1632ed2ad571084006936c68328e307821"
    sha256 cellar: :any_skip_relocation, monterey:       "fc8b7da92ed871943a29875a7369dfad8e0e13ebe2575d434f579b975b882094"
    sha256 cellar: :any_skip_relocation, big_sur:        "b750f9911286141fd11b733229093f1cdd2cbb00264aaf0051a798fcd7a04c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c2b84b14e0fbe4d65aa373bb89b9f92df84f27afede41604607df65defa69af"
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
