class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.19.1.tar.gz"
  sha256 "4131a891d68352d20fed9701bcff2df148527de4b9e8d1facfcf867be7f4619e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe875634f09789e9758d927599cd44185117b3fbebdfb9b2342b61a5411dc3bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18c9914983f0b92d51aa6f17d0cc9c445df7c15871b732c06a8af3dd339cfd51"
    sha256 cellar: :any_skip_relocation, monterey:       "8eaa2c9ae0c844c31ce5714f89e676a231210e9a26b746d5f9a30691a2f85df6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e566971a6b9ce9b93e6543d00055e65d2819d040a7c965fe0f9428bb11e0c879"
    sha256 cellar: :any_skip_relocation, catalina:       "25a6c0a0010aa7b3612f9d8ae90a58d95f09a146dd6a793faefad50a59adfac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73ddbeb43cb607abc92102242ec61ca9712adb8708b212497b03f7e75b854eeb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/cmd.kubecmVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install bash completion
    output = Utils.safe_popen_read(bin/"kubecm", "completion", "bash")
    (bash_completion/"kubecm").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"kubecm", "completion", "zsh")
    (zsh_completion/"_kubecm").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"kubecm", "completion", "fish")
    (fish_completion/"kubecm.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
