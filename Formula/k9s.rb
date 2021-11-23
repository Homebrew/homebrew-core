class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.5",
      revision: "4ae57817bd4f7b169461e39f2f8aa506fa43c79c"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6af47f7ce37a0d1272ddb34571ff51d3fe28c58dbe49003edd32419b7b842e26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc1315624454ae02fa81365c3beec4df39b68dfeaf09adb07defa56a435f7873"
    sha256 cellar: :any_skip_relocation, monterey:       "6dc2f02dc977344a004906f616e0a15de67d34691f8a603a25391087e262a7e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e29dacc81ecc88124097b064cbcfad0f13e914da289b81696a68a0214f5e1bc"
    sha256 cellar: :any_skip_relocation, catalina:       "ebf7f6f118a35eefaf7083097c63e9087fce9971423ca9fabb0a039ed77b35c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80464250138122423d1a5c5e7a3cce3ba730c5f67b0bd0c8b676fffb7ce0362e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}",
             *std_go_args

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
