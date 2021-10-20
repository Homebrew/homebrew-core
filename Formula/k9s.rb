class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.15",
      revision: "8e41b76edf15f7eddc46cd75fd45d27a30dc9ebe"
  license "Apache-2.0"
  revision 1
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db8f666a4a449636b6ff5b2aab81a1029813ed492dcc82f7eaacd15f7ebc24ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "c95b74ab0b03b7e72c72d80501bef0317d33beaa40395dfff8763274b0dca8a9"
    sha256 cellar: :any_skip_relocation, catalina:      "19e1a184b7f609825aa1d16684aa04c2c41789ae505bee96f9d8ccbf119d7d65"
    sha256 cellar: :any_skip_relocation, mojave:        "aff41d6be560246708b5f7fbce21495190ef7d7354997e905dfae6ea94c54027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "158063b2e26be4ec4eb93cca2d9b7939689a138a3fc06251ad0bd406922a17be"
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
