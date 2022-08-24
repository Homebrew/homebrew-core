class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.19.3.tar.gz"
  sha256 "fac64ce68b69af9e92367b28b12b93a2162d8e4cb683d6f18ecf56ef1c182cd8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f7e70eb9fe80f775b84330b4514c138c605006ece4be20c59b1aecf47c3dfde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a02ef59053b51f47d78669e167c48a12bf2e3036f86571e0f7a9ab709036b752"
    sha256 cellar: :any_skip_relocation, monterey:       "570c3cb5c09817f65d89d567b14812d10803146f1697f536f5cc1c2ef246eef5"
    sha256 cellar: :any_skip_relocation, big_sur:        "798aaeb99741e0accc82a3d4dab9fbda9c06e5c4de83cc131948c89ac3851b11"
    sha256 cellar: :any_skip_relocation, catalina:       "673f37a9fc7e0fefe7595d10b4b479aa924c788bd1f84f575ec2657bb2d38742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52cd70a0806e4a5cfecb2ab8f359cc9facb4a813348cf7b1e25e9993a22b10e4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
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
