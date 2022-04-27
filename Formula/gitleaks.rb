class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.8.3.tar.gz"
  sha256 "3e1d680ff36ba3c24ff120f33e04a22da593cd8d172b2d9244716c37409226f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66fb3c17d60def6d4934133c138702dff146d9f342e7b36825c164e5ac90fc37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1f1cb22ec98eaeba5d0657b97be748c4daa8ca9c679be49bec89e0a30e417cf"
    sha256 cellar: :any_skip_relocation, monterey:       "8a7014f62a4817886ea78fd0dcf27ad658721253eefcad6629e570bc846991c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "89265bb860190b854445f31a77f0408e5ae2ae0b4123706d65334a565ee767fe"
    sha256 cellar: :any_skip_relocation, catalina:       "290f20b43759b9ec9bb587bdec84357978daccae8d98a109b00cf2b267cb1ef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a480868455ee1648a6d2aff36735414cac7f536b53923b47a4f90002d9d788fb"
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
