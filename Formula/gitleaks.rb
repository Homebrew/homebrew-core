class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.10.3.tar.gz"
  sha256 "c5d907629da492fa0bfe267e616db309280feeb2f2ac7afd3c771784c2586476"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6521656690c848855b46120d16cd1fbc490d7990593361ec25cb27d23c5313b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "366d34f62d6a8c6980aa2c782ccd42aa5fceeacc56a062f021e078229a624169"
    sha256 cellar: :any_skip_relocation, monterey:       "3a0029de55020b08bd206ee3b1698e62431fe6238e724cd44a0d49de66a80bc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "aff44196b5933c2585f4bc2ec94ef7317f51f0a3e26dafa8eafda9a3f9046aa9"
    sha256 cellar: :any_skip_relocation, catalina:       "5490d95751751cd918a60439a06d17e2d0d458ecb8f98fa9d9c498368b1b4fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "045e50dd003d8c1055aff797d8796b5e3cac9c9e6dc17a561b25a44cc05ea633"
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
