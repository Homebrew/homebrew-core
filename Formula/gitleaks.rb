class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.4.0.tar.gz"
  sha256 "c6dd0c006569e26a935ce0bc85dc73b4387cc709382b8163f11c6e53519e792e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b891a46f29b0b4a227d99b3087918126e967b887f238f8f475b8f4322818c8dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03a0a79023a6c0cc39b96e00cb3565b9f9136b9baf21bef2ec906c9eefc793c0"
    sha256 cellar: :any_skip_relocation, monterey:       "d63fcc86f52f64578a1b4a369fe774f76ec72111fd7c64391a6ea0923a32e2c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "019d8b2de38c920076e96850f986e53db1c06fb063d0a19debff4d102561d76f"
    sha256 cellar: :any_skip_relocation, catalina:       "6631fee4415d261de1b73c8eb6f3995248584a366560f023a0847ee2ffc2d802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f9311b592293cb9bbcc6a651f5f14c4c18651729fa7cbc8259b023a98e5848d"
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
