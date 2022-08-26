class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.11.2.tar.gz"
  sha256 "408e4b90f5a451a6f37a2a33553ed9f913c6b6b4ebf8db4c68ddb85cb0a5cb0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f58621ac5b626b6008d88f59b4555e1e5e9042389b013f770c762b26369b8e18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0bf26deec50a6391d9abcdd778c6e6f574c3db32d82dd0bce3acea3ec3b4aaa"
    sha256 cellar: :any_skip_relocation, monterey:       "d842ffe30a3d998497e235f575aa439f6543640d4478965ce5d2581ef76453db"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca5f328fd92a154e2f5ff91cede517f56b71f1c86a64edf25eed3b18f7c3e2e2"
    sha256 cellar: :any_skip_relocation, catalina:       "6c24d0d6abe5b9793b141fc6584dae1ff431c909bd27f5235a8143c0c87c8abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec0ad665feda24a9d2eeaaaa704c53a0ef33782bdcfef97524da37b728a2f007"
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
