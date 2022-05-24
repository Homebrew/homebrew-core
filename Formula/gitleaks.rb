class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.8.4.tar.gz"
  sha256 "7692535fb0011d3ad9c6b1effd0f501c1b26baf5c720288384d459a8c8f951eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02874090a5efa08cf72de8c476049e964789e51c15d3afeeb2a0c4d4b2cd5dd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "142be6860f75c2265e0b4bf23d1548837362561384552ba355ce14f33599acad"
    sha256 cellar: :any_skip_relocation, monterey:       "e3cd6dc32f212e5c9bf8ad76ce22483fd1676e3522757708dd658426422a9e00"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7d5e91488d917963cddf6f59e794af14a108c85e031cb981fea6dc52763e3c7"
    sha256 cellar: :any_skip_relocation, catalina:       "147ad2dd94424903344eaace83e0de0ebfcc350905ea23a31c65d60abb2aac5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaff584b110c12e67e187b4e1cd41242cc94696e6a3e408cdb44143251b47124"
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
