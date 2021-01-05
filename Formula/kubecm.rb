class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.13.1.tar.gz"
  sha256 "b314688d4990cb3d0875daeb4ae0e2fa883709e1ab654659ca19812dddc0095e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a983a73d762316662a7aa92b5692321f5a8a960199820334199c79efede99163" => :big_sur
    sha256 "6720d954d186b3da5a5ae39aec15ee8cf7f51108016bb769342ba99e96ebc688" => :arm64_big_sur
    sha256 "4584fd305eaa2b5c81c57d8d01cc258af880f1cf58df9b5aed315237ad1803b9" => :catalina
    sha256 "8ab23737c5c10d27109292c1dca60046a35047ad7788afe775ff6f5d7c9da226" => :mojave
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
