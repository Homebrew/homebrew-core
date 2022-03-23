class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.5.1.tar.gz"
  sha256 "91d78481f033fd9bdbdcef04242c6ab875bd1ba0c2efa52449be56c5f35eead0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e3a3e8cd75a9afe71da6ea9dde6aebf05786bce0aef206d455c74b6c957fdb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a13ead83941dd134b763347ecb5d328f163a0122353528d6f7d1385c25af5ab1"
    sha256 cellar: :any_skip_relocation, monterey:       "c15fae7dcb262a056359313df93abd5d46b05fdc1ada99120338a16507ce427c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0ba7e96285d70c85eb64537cf956edfb0d7167e711fe8c24ceb839a2586492b"
    sha256 cellar: :any_skip_relocation, catalina:       "e3925260850bdd3efcfacdc597ff01ba9c613abc1d190ca0fe9b67c9b3adf766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7147c2b9acb0f1fbfa56f5e4fbcfde495aea3fbd2ff6870fa019ea4138db49a2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"gitleaks", "completion", "bash")
    (bash_completion/"gitleaks").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"gitleaks", "completion", "zsh")
    (zsh_completion/"_gitleaks").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"gitleaks", "completion", "fish")
    (fish_completion/"gitleaks.fish").write fish_output
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
