class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.16.3.tar.gz"
  sha256 "f44edfb0b0a709b72309a84abb5bfe2e3408ebc87937e3f3b7dd8cc44fc3219d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "963191a58acd64f1850727ef85a98ba8152dcf7892058f5ea5f88b992650dda7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72db3ab2eb040beab05575160702e1badb7b56f448e3fa99d186ccd717ee3f93"
    sha256 cellar: :any_skip_relocation, monterey:       "55457ff2b2b63f598a4cbf839988201aa28e056f4724024fa605972f253b018b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3225ac3c412f809d1d37959bd29d49716c6a528f6962e1a314a6632e22afd34"
    sha256 cellar: :any_skip_relocation, catalina:       "c5203b6b68e268bab2b2603a1bfec4db4d23782205de930e22fe0b005440adb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb2ba6dad5e4e636fdd27caa08fd3fb5f0befb57e2417015925ca3d56240247d"
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
