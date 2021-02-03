class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v0.3.2",
      revision: "18f184d57c6261515033a509ae76a4f70752fd56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d9174f9e53ae431424f8948cde4e41bb60799f9aeda0bf3843fbb97afc119c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "89add22f5dfe2712d9b866d7f6e6e6ee0c141705d47cab626b52533919f0c782"
    sha256 cellar: :any_skip_relocation, catalina:      "6fe31431444bd35d8de6fc58438f8db0f1979ad1a0edf3ec052c6851d0144df3"
    sha256 cellar: :any_skip_relocation, mojave:        "e5a432d0c8cb50c59c6067f7f3a113d91d4cf7a17458920e5698333c50cbf389"
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
