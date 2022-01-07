class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.2.7.tar.gz"
  sha256 "bf5ec1010b2f7c5031c21152ebdfbffc6e721690f67aa1f797c148e80834ecd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af32343d81a8904f3d1b1f7aa9d8dafdc333a3957e2d978d83e4e6583bc0f444"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "822a222b8d424ab0c950bd1aba1e3b9663bb882c8a90da26f783ffb62a0cefcf"
    sha256 cellar: :any_skip_relocation, monterey:       "d47c8102f4df6f7e1fbe76e2d542b16e0b4076707c10c27e97fe14cee31729e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "384ab1a07552290ad7d8c7670b0dda7d4cf05aedbd3f1fcf6110b3934b1aec23"
    sha256 cellar: :any_skip_relocation, catalina:       "764824f55e2844ed78d4f21e40d0244b9455447985ae0018994ede412a10ece7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "078416a2e6b69c7afbdf1dea9bb4d32257eeaea57657c380431221b586096892"
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
