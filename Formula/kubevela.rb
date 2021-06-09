class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.0.6",
      revision: "5d9b3fbce6dc2eaee69dfe664930df3e553d1176"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "befaa1a9c12afa8b198f93fee1739ec1ce054729886e77e6ee377df7a7bf5a19"
    sha256 cellar: :any_skip_relocation, big_sur:       "e5afecd7b0627090d37f196adc9c650530c727a4df1da33efe6d4a5f14ab87af"
    sha256 cellar: :any_skip_relocation, catalina:      "fe49241632428626d0e4b6070ea08cfe3914dc725fb446fe0c18382371f63eeb"
    sha256 cellar: :any_skip_relocation, mojave:        "2bc5e9a4c6797259e7c68b15ef444f0d7dfd315422e72933bb9b76cc17e09c5f"
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
