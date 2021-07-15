class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.0.7",
      revision: "44e8352d1e3f47f60cae25ebfc6fc590edfe5fa6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b5db08df706d97e2316a3475438c34e3b4b0669e6b84c45118f9bd9a8a52c4d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "473bf094962235be87555ec7d0dc6effed7956b8acf3179bcfbbb8c512856ef5"
    sha256 cellar: :any_skip_relocation, catalina:      "dead3061d729508c804bf71744b373b4354a202d437bf5f64e6d3c673a528152"
    sha256 cellar: :any_skip_relocation, mojave:        "10f215c9e2b9e456035dd8012b269858a4069249c43d157d05b661ac853500cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e06d2e14f5321fe6f4424e94624ea3dfa43b40daa415adfb8c121cf2be4690b"
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
