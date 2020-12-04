class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.11.0.tar.gz"
  sha256 "5eb167b3f461c5f3823807b6011e56dc278aa4946bc267a65cdbe993f4fbf09a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fc6fde9e70d5d0e28a072146d968ad8eabd8a0be4f99114186d65eb17b3853e" => :big_sur
    sha256 "70591319262522a3b74da1ab1eb68393b0408cdb0f93d822d59ae70cdc055209" => :catalina
    sha256 "3e20f88579da94a96efcb3d542f19f93e9b49775fd94590ed607607a13b08c17" => :mojave
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
