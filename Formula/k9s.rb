class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.2",
      revision: "81823ae167ae8b8d7219971e3fa87fccf7c8f6c3"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a32d14748230943cf1b230d478c535cb9636ce5a70583fd3db231bc0fefb72de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4a5038cd72d44bb1c7e8f60d0960c302830ad4e6e86d3bd486642d63d01c8e5"
    sha256 cellar: :any_skip_relocation, monterey:       "8ded4dcf5d4a317ea2edca1da0038008c7c22bd369bf67f3862c972e90d10505"
    sha256 cellar: :any_skip_relocation, big_sur:        "02e3eeba4d339c83420996b5f752c63774ed1b04d134b29190cd6d839252955a"
    sha256 cellar: :any_skip_relocation, catalina:       "9539d8cd2d5530bcbbb9258a3c879e51a1605d4a2e0c92c1318bf9b30ca6f086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c141778cf86989373ca812e84ac4a9debbafa5edfeffc6544bc7533255c89e2"
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
