class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.14.0.tar.gz"
  sha256 "05399c517ea632849e2f500ce50f0b95da97fecfacb7e129b2b4d51dbf80f0cd"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2329c999724d487fbf5d399ebbd9c9e3310afb3a1930ef08bdc2dafd4bc09bd5" => :big_sur
    sha256 "d2a5bb547ac0cee959027e050d0c13be6fadbd7d5495dbab3c16718f1367beba" => :arm64_big_sur
    sha256 "89f61655a8938e8c2dda4f4c0fd3495af27a21b97c9c740d0bb178beb02589c5" => :catalina
    sha256 "f43fad36e9155003c5eb05f727824a45305fca25fe32fe24db144c1c08e8e87f" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build",
           "-ldflags", "-X github.com/sunny0826/kubecm/cmd.kubecmVersion=#{version}",
           *std_go_args

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kubecm", "completion", "bash")
    (bash_completion/"kubecm").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kubecm", "completion", "zsh")
    (zsh_completion/"_kubecm").write output
  end

  test do
    # Should error out as switch context need kubeconfig
    status_output = shell_output("#{bin}/kubecm switch 2>&1", 1)
    assert_match "Error: open", status_output
  end
end
