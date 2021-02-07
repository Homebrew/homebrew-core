class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.15.2.tar.gz"
  sha256 "c15f9ca997627fcc3257208a0521b36d7e6112cff8b5d3ed77211bfa503a731d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "beebaad0ab603e01b1df73a4d156af1e755179149e7ad482f4aa8b9f4c9c3896"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f1bfa0e00ec2b865e08066f6a29f576de28de5c0e11143115d88aaac713246a"
    sha256 cellar: :any_skip_relocation, catalina:      "ca5325c09fc0dc5658d833d3939a219178799512fa81f5f3fa5315aeefdb61bd"
    sha256 cellar: :any_skip_relocation, mojave:        "e710a125f19e2b3ad043d9d7b917a957ebd22519a463ae8970cc042069816562"
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
