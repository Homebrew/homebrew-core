class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.15.1.tar.gz"
  sha256 "558c766e88f40d1cc86fa8fcf495d040a24e67b0fef392fe3b0d0b4436ce6a8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9c063e2246b4b2a33ca1289fa2f425e426d59371d306dba91c3aad3df65bae69"
    sha256 cellar: :any_skip_relocation, big_sur:       "30d33110dd11731e16a97cd0051da789097693b776a6840d9ace343641416f9d"
    sha256 cellar: :any_skip_relocation, catalina:      "8d06b3ea72107fd7577048d5490aeaf35f6fa570ee84e18cfe95ac3ea5c7a822"
    sha256 cellar: :any_skip_relocation, mojave:        "89760c4372178e1cc4d59380ca90e76e4c9d43d037869d8420cc55ad03540887"
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
