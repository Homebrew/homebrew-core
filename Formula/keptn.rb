class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.9.2.tar.gz"
  sha256 "0ba9f79f3428baa2453622e19eeff2a325c36b35a5b22f60b4589ef77cc77826"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "151eccb7ed8900300b420347b0d815cadc503c3568a4ec2463b40fcbd0fc8707"
    sha256 cellar: :any_skip_relocation, big_sur:       "41b0576f74f2f35573f0a5ea9452998d6cb7c133b9790c2992f2c93abd59c48b"
    sha256 cellar: :any_skip_relocation, catalina:      "8536865a76351de62977493328319a4c72858b9d1fafb8ad1b4d6147ab8b7aee"
    sha256 cellar: :any_skip_relocation, mojave:        "ccb7475f5086bbb219979a63bcb772c8139fb5c88649a3568b098911f30ea651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4467137b6f965d28701ea01d4ce7d7ef3acf4a80154532660c9c4a1401ffd881"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ].join(" ")

    cd buildpath/"cli" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    system bin/"keptn", "set", "config", "AutomaticVersionCheck", "false"
    system bin/"keptn", "set", "config", "kubeContextCheck", "false"

    assert_match "Keptn CLI version: #{version}", shell_output(bin/"keptn version 2>&1")

    assert_match "This command requires to be authenticated. See \"keptn auth\" for details",
      shell_output(bin/"keptn status 2>&1", 1)
  end
end
