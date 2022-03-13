class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.4.0.tar.gz"
  sha256 "c6dd0c006569e26a935ce0bc85dc73b4387cc709382b8163f11c6e53519e792e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7832befc5fc114712b655568061393cbe8374b8c3ed2be957c85db0a288f751c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c82b95f4fd27497d299d0e0428588a65a3ab9bd24a92d80607beb3f998431f4"
    sha256 cellar: :any_skip_relocation, monterey:       "69a8bdd174184550542b2f7e98062ea4f285a01fdf9076afb7877bcc8f8102c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c5f8eab998de2c5c0fbca8364f69fee71ade5b36e4dbc40e7b3a80c14714eee"
    sha256 cellar: :any_skip_relocation, catalina:       "8c986841283afe4fd3bbe852dc8f29807bd9ff1785fed7c50430f1365639a165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d38c47898eb40f5f9a8159c2dbe65fbd207d422f5ff33f65677ba927a3ccfd8"
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
