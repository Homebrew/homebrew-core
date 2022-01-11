class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.2.7.tar.gz"
  sha256 "bf5ec1010b2f7c5031c21152ebdfbffc6e721690f67aa1f797c148e80834ecd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8840deb078c6046f329c41b40ee625e6de66bc7ec6bfdb064b035e4948d6ca9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "572ce8429cb425d235b4a9d82ce53b752ec35246913e5246395c476a01195d2e"
    sha256 cellar: :any_skip_relocation, monterey:       "b5af65caedebfabae600dcea3688d43e220bbcb16d653aa9e5c33d0bb6c11a2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "70d7b05e9f51639fb0fd01a70a940300c4fe0d769aae3db9d34964c084a13b93"
    sha256 cellar: :any_skip_relocation, catalina:       "8c609541c9a84cdad7afe0e1d3f43b4bf6e397a86b9564a3bde706543b1b8c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a486bb74ed4dd2a201cbcd1c8d9dc0b1e35180deda4d2c46c4bbf2b246f6c2a8"
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
