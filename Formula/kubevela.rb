class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v0.3.2",
      revision: "18f184d57c6261515033a509ae76a4f70752fd56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "f15510eceaaeb28476a955174eca2791b841fc854f1a88752f636051205f7e2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "38ba50cadac94fcabe7f3fec9b990edf1ea89f07ab7ffeaccf973b250103cced"
    sha256 cellar: :any_skip_relocation, catalina: "39782bd96b58280b9c49303e8792ac3c769ea1d1be3d4ce2f9446719ef0c98b4"
    sha256 cellar: :any_skip_relocation, mojave: "b38887ebf806f920d2fdf5241f35840c80d9669b8a73ac675143920144dc6d0b"
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
