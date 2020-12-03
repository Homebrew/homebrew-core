class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.10.4.tar.gz"
  sha256 "1a39d653bc27a1ea7bd70c1d4e624ef0dcaf3fd775fe60308581647dce49ac85"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ddc7d190b279a4a2a1de4f5f5fdaa25160ad42479e3ebfe08f72a52218615c6" => :big_sur
    sha256 "b294304b509746dcbf8643398358fabed896806f706976bee91c0d67c1f98bad" => :catalina
    sha256 "a6cc76519b512e575eafbf861ff01ff05bd1a1cffa593f6a5d7e28c7d207752e" => :mojave
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
