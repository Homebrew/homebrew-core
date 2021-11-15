class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.16.2.tar.gz"
  sha256 "38a812f6ee37493e8297ef4db4061a8dd1c466f72f6e0f70ec94308e8b107856"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c7b63f4aebeb174bd07f1c5c4cffb349ed4c7c87982aab87750e1f35509f143"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8d936936a486e386e76893d5dfd6176ba9d37074711581264314087bcd441a9"
    sha256 cellar: :any_skip_relocation, monterey:       "ae8e405b30526327d8babede1385906071ce9e1e2f965a534568e2bc24f919ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b2150deba0d37b53530f17f53a89a0278d8db1e61ff0e2db82251506fce715c"
    sha256 cellar: :any_skip_relocation, catalina:       "4f3a90214ae7bc7bfcad717b2f54ff622cc27c732a3dd3cb723270f43c2dc753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ee5a5f0087572d00c8d73c98b302fb2f0000432e23328c3f9969ed33c018d0"
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
