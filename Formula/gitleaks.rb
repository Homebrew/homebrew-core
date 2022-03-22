class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.5.1.tar.gz"
  sha256 "91d78481f033fd9bdbdcef04242c6ab875bd1ba0c2efa52449be56c5f35eead0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0245c2fdf895727a9dc400b03fef220e8cb7836fdbc9832faf8b488c87df804"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c46caf95d1a599418c8b181aee9291757b8b38c61d7662dc4c42f47b33b4cdc0"
    sha256 cellar: :any_skip_relocation, monterey:       "4c62953e7a6dedecfa562a4b892c1f47982cabc190c8f15abe4056cecfdc7a8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fbfa315738a69e7d5392086274a1d480fad06c85d5ad4322f4e7b298afb87a7"
    sha256 cellar: :any_skip_relocation, catalina:       "82d86155312843f3754a23a33a5eff108b158c8a7e7380a17bbebc09b5e19208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8418b9be201ca31c1bd1840aaa2a470bbb86618a85c379d9fbe0a97a07fba1a5"
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
