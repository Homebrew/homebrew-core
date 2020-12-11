class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.13.0.tar.gz"
  sha256 "d9b42c57ef88fb5ca268a02254be0e4b2ed211e7a7678fb8d1463dbe00900247"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "665567fea57ddf388cb53f886b15580d13cb239a9351e2ba2a4727a717f2e145" => :big_sur
    sha256 "f42be8e4cf9e384b98934c2fe2e73e08c066d70ec96804d25136bef741b2abf3" => :catalina
    sha256 "5c20847c62cba87bf8fc7e5f181ebae64cf2a77ebfa6bcc25e11c246b961d25c" => :mojave
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
