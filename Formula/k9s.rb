class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.18",
      revision: "6085039f83cd5e8528c898cc1538f5b3287ce117"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61f4f1765bae597c4bd288ccaf84bc062d83d290e10090c7af74d92c3d4bc9a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc20f4d6444fa8ad5895d02549924e260ef9aaa5028be832bb8e661c307f0fef"
    sha256 cellar: :any_skip_relocation, monterey:       "cdda90f71dec5fdd3b21f21aebd6fea5ecaa08e8f84431df5bba23d9f4a5e80f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b04dfa7bd27ac40109182e6c589a74a084f4eb445e0897027078abf162101532"
    sha256 cellar: :any_skip_relocation, catalina:       "33abeac3505ba72ce55603b8793c3e4a408360ea9e151e45e4db2fa825423450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65e04702661176db03dfa45584b10cb8b8cbc3b46c2306a90c0b636b1279ddd2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"k9s", "completion", "bash")
    (bash_completion/"k9s").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"k9s", "completion", "zsh")
    (zsh_completion/"_k9s").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"k9s", "completion", "fish")
    (fish_completion/"k9s.fish").write fish_output
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
