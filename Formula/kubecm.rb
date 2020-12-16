class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.13.0.tar.gz"
  sha256 "d9b42c57ef88fb5ca268a02254be0e4b2ed211e7a7678fb8d1463dbe00900247"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a983a73d762316662a7aa92b5692321f5a8a960199820334199c79efede99163" => :big_sur
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
