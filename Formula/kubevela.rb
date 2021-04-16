class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.0.3",
      revision: "3800a700b012954f6c07d79d3838d826df7f4064"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62f039257a380c0c7c26b8630f7153865e80f4fad3ffa51adbd00d09befd36c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "4610fde53315e961b80df7f6aac1e42a30bdefcb565c29e9c6d12a0ae28f230c"
    sha256 cellar: :any_skip_relocation, catalina:      "f50f99008e1648e088bb4b67cd9dd1bfa58c31f47664d6b24c433e4bf4fd076f"
    sha256 cellar: :any_skip_relocation, mojave:        "d4553e87e0128475549eebaa3d90805c81184492d001811d8388cdb4d58307c0"
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
