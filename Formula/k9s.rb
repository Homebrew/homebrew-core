class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.17",
      revision: "2a9f5464c38f3c303da03da89eefc6661020cf28"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5860a1fa8fdde95cea902aa6244b9545b91782aede86906de89c0b5b6a0edaec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5334af98345bb5b21a94122acd3c25b6e5b3a417bcf5714a9d5049001c11718"
    sha256 cellar: :any_skip_relocation, monterey:       "192f49e6e7f9bc165e8abfc617452af0199b65dd97e0a073fe69e41f56399d86"
    sha256 cellar: :any_skip_relocation, big_sur:        "b851a361af5d9389a4f218fb1fe414b97157f9149f06694dffff2c4fc13307b8"
    sha256 cellar: :any_skip_relocation, catalina:       "2d4e786dcd33be1bd2f327535b95565b05c1e4858631ca3e357cdbea99fe770c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe94bdfe94a3efb62d24bb040892cf01008820ab72ceac2e9103b9f1408ef464"
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
