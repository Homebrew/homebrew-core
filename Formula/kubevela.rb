class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v0.3.5",
      revision: "3bc014bc8c8ff915018441e7aa2b6c4ce44c3fb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12c2fdbf365cc6572ada95c7362ef9d3a121636c015c09c79e5493b64824cf75"
    sha256 cellar: :any_skip_relocation, big_sur:       "2835fb3e65cdbf6ce0f876fa62a3654eaee6bc69a0ee8604d1e308e4f0854263"
    sha256 cellar: :any_skip_relocation, catalina:      "cf1942e9448ab8a1e8b972f9c130cef2488b5e4b303ad34a21785c9eff3d0403"
    sha256 cellar: :any_skip_relocation, mojave:        "0f5e224da4fdf09bdca0a4becb6847e70e2f3ac48e5d7eeddc20e4eb176097fc"
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
