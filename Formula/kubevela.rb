class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v0.2.1",
      revision: "bb6b050d158e5226d81caa2749daaa11edae586a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3a7cf287d88fbdd347424f965207303a20e2487dd9cf41cc22f59dcb876f571" => :big_sur
    sha256 "3a58d9e061245932fb0ecc5215cb5ba509b1b8b23de528fe585f8c4667e36d9a" => :catalina
    sha256 "f888334b304d793720e5af1ebdceefe32873dbc8fd1b8fb65f4af0b341f551fc" => :mojave
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
