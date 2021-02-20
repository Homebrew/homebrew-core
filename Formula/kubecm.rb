class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.15.2.tar.gz"
  sha256 "c15f9ca997627fcc3257208a0521b36d7e6112cff8b5d3ed77211bfa503a731d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ccdddd9914c7b94857e1b63abc5af158a9c1effc4d3a47da7373ba8e6f8a0307"
    sha256 cellar: :any_skip_relocation, big_sur:       "d13565452a24c97546f51b0e7270536d6904a7d919f105e3dcc6e070c6e0200b"
    sha256 cellar: :any_skip_relocation, catalina:      "b32b34bcb811894654f350b3a8c6f5dc53a2c9b03e9bbdeaf63a28bf72a1eb23"
    sha256 cellar: :any_skip_relocation, mojave:        "dd8c1c10a250a07d58ed90c1e65c09e1ffb082931e55fd403ef8739a990c956c"
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
