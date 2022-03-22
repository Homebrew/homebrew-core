class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.16.3.tar.gz"
  sha256 "f44edfb0b0a709b72309a84abb5bfe2e3408ebc87937e3f3b7dd8cc44fc3219d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff25df4c461d6438e41844e1020bde37d5a7a60cf8f04299cfed5a589263ab31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbacd307efbc06b15d58d2cc2e1b5c0b1e6f0a23e349502d128b46a85f7c2a05"
    sha256 cellar: :any_skip_relocation, monterey:       "e01340badabfc01b873e570367f5532ee10060de91a5cd8f8a692cee1b091879"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6170f726d332a7b95eabda20246fb8eb099e4996374ce69d0998ae94e1d3475"
    sha256 cellar: :any_skip_relocation, catalina:       "ac0b49cbec7f4f2cc91bc4a0a270a3e17ebb890efc57856c7412df84e10d39dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a161c51b0bdf688b8e9933db16a131ef4fa518b916d12e536dcc4cdb401ee34a"
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
