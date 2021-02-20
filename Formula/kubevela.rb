class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v0.3.3",
      revision: "f6d2e76102709f6316961f564f8390da226a796b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e53a13f527009b04b5e3e5eca85712be5155d8fdc1bfaf2d3f3f45c6918b2a8d"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c81d1576af91ec63d802d5bcae5802558813bc8cc109371340fff6d80603820"
    sha256 cellar: :any_skip_relocation, catalina:      "9abdfb74042278faa52fe950e7553e9197261680f8c330076371529b9d27e7e0"
    sha256 cellar: :any_skip_relocation, mojave:        "5d219fb7a90083ee6a2b214d0ea558550d70abf29e6593cfc848129e8171561e"
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
