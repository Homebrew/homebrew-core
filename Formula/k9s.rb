class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.6",
      revision: "f0b540a350b44009b06159d7cb519f612990431a"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d50e319680cf228875c8422e530822f84c53e3e4ddd9955d5d3688ba0e7a82f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c42d09f23c5cf617be3e41930e9b59695327ecc44170e6e52d761aa6fa531fe8"
    sha256 cellar: :any_skip_relocation, monterey:       "7acb785c0bbae40e6886b5ef499512b222978aa63628ed434bbabe8e8c6a56b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a84fd3a00504255ec9c1fbb5fff8e0af93cbc126bad16b21477f1557c95833bf"
    sha256 cellar: :any_skip_relocation, catalina:       "e80807f18cf0a2b12cdb15fe59888a44e584659e282d08803606e434c9eefbc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acd25d8624980676af05b1776226e9ef7aa92edffebf279462362b872f070723"
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
