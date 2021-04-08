class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.0.2",
      revision: "08a1dc5a22dc5e4bc11ff1f4a699077d923b997c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff53a1b763ba02bfdd0ba708c6e61c182f52533bdf82128dadaf3042c71602de"
    sha256 cellar: :any_skip_relocation, big_sur:       "2be99be5cca26877dc3db3da3ab6f7da4ac3b89439cf617d653706e6a048a930"
    sha256 cellar: :any_skip_relocation, catalina:      "0c5ff9bb16df941887019a3053d68505761a6eda839e01ed69c615578b033bec"
    sha256 cellar: :any_skip_relocation, mojave:        "9592a5b2a438c98103fa5e546ca19fe375887eba1842d0fd5d26734eacab6c1d"
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
