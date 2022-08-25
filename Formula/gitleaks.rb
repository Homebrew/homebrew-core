class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.11.1.tar.gz"
  sha256 "f055dbd0d9ecb01890cb7cc7452cea72304e1476934225cc6a3929d0caed8cb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5101fdee4411a7339cfb96418c91e17302ff1d5c7c0b322d679e8d778d48cccc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdaedca0da62a36eb39f9010196f861039363a3a4b87cb9db6e13be9fa510dcd"
    sha256 cellar: :any_skip_relocation, monterey:       "66a67f3472a86309d1127a2a1fbb1052c59a664f404c3872de8b17194b31125b"
    sha256 cellar: :any_skip_relocation, big_sur:        "41938ac054e58e0135d9f5a6c99109fb8374dbda0a46defc9c768aecca120d3a"
    sha256 cellar: :any_skip_relocation, catalina:       "f073a5258b96597c223920fc9604e7719eae864a0d23ba4e10907c2cd05cb0a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7882205a1679633457281009518c17fb0b7ffb9c408d95cd39fa3f13d3da5a72"
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
