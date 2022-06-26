class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.17.0.tar.gz"
  sha256 "b1e1a34174f5178107ab62af95f10d016d5ae271ac13b6066880393f6936349e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb23e43199db2bed986591e26590efd430cadaa5624b7606448dea89573f90ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f45eee10420a583354c701ba9568e3f04900e7c568c79b3e15e10118e359fc77"
    sha256 cellar: :any_skip_relocation, monterey:       "5878d7081fa72b8e227bb0a8747f0bb5f52de20512b8baada59ecd09e174a39b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a85ad1707d0804573008a17c556c42f223c6ef8b4a76a718f9c683782cd6032"
    sha256 cellar: :any_skip_relocation, catalina:       "2ad3563dc22f7b6febc8a8c6c895fa72e1ced42df7853ba939d02ac83446f950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2e11ccfa877f6d8041e3051b9c31366d011f9617f554d65ff50ad04be4bfd32"
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
