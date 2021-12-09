class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.2.0.tar.gz"
  sha256 "a76e310b8920a6b6cffd713d8511a7220e333149707621b888b7d8645675c9fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd3a349657897ca2e5d69a57d8bc59d1c75f84056f07a5a42680c2247fd92f68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11ed67d1adfebcd012aa95b89f2c2755203cc97e164699a6f9f7ed2aac3d5a49"
    sha256 cellar: :any_skip_relocation, monterey:       "0874e77359ab34baba9ef86af17fd768d6239129908259964034f30a3e6269b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae25f4b8c9c239b6664a803bed43b2c6a91b0d7ef728d91e32e5148edea94e1e"
    sha256 cellar: :any_skip_relocation, catalina:       "b66615a5a2e755385dbbd323a8b60e189c6f135d4e390d6009b2e90ce7585838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "945de350111a4b4dbbe6c7619bddc37621f70393fad8e9313bb3db65f749fc07"
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
