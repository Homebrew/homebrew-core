class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.0.1",
      revision: "1444376b0cf17add8c818078fb9496c23c45ed32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "88d3afa0cddda15bc4f610c41a4e5a8f31b6ff93e7f1cdb77b32df0349c3c73f"
    sha256 cellar: :any_skip_relocation, big_sur:       "69ef95c53a9f3d910556fd5bbb924d878d3fe3740fe2facd7690cea928c5cefb"
    sha256 cellar: :any_skip_relocation, catalina:      "7404b6de145e25c518f30fabcc1b3baf06f9272f4d2bf26d559e888172284657"
    sha256 cellar: :any_skip_relocation, mojave:        "e16560f80fb4d20305f9bc7a5a8d52659592c2645dc9aedc624f91139a6f5caa"
  end

  depends_on "go" => :build

  def install
    system "make", "vela-cli", "VELA_VERSION=#{version}"
    bin.install "bin/vela"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/vela", "completion", "bash")
    (bash_completion/"vela").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/vela", "completion", "zsh")
    (zsh_completion/"_vela").write output
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "Error: invalid configuration: no configuration has been provided", status_output
  end
end
