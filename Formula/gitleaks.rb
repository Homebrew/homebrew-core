class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.5.3.tar.gz"
  sha256 "0d8d9dd11c4e609714184dd196adcd9562d834f0fdd45106e00f906e9ce6ef0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f789033262a96849ba74d5dbc525739ebae5e695476b8cd9781276f4d665cff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fe792282142a41c2db38440f3aa8d31f69913d21246e59e4e9cc67c74a6d695"
    sha256 cellar: :any_skip_relocation, monterey:       "0a3fd5d978709aac5552d44317d70c30a2c1f71ecf32193bfdfabdb65cf5ddfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa582ba044af1e9c5507db89f7a68f908bde84f53e9f3e21769550bf3d83ef42"
    sha256 cellar: :any_skip_relocation, catalina:       "6a49b74f3356158971cc1476fcbccac38d1daee3e95b45f82abfd46a6c6ff2d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03093a7343f752f6b806a0b207b86ca9c91c6bab673056bbdb3523865244cf24"
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
