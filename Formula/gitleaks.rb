class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.8.11.tar.gz"
  sha256 "18b7e0889f54c96c4c948b801e687dcd8859c0f602c76359419630f8673489ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32d42ef0a2dfe29d67774fe73714130c75293382be9ecd1776cda23ac7c28776"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a785d0e30d4494995f81bfde9c4adf405ea4405c0cab102964e9d2b95664614f"
    sha256 cellar: :any_skip_relocation, monterey:       "c8319b53b5a76caa4059d1cf91d8f19fd48f05600aec1c47c238fc836d4813c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "88b71d822596fd72733fd907cd079f2334278751513bdda4a2220ca23e75fe0f"
    sha256 cellar: :any_skip_relocation, catalina:       "bce47ff7495686d15e8ebb3f2888ae7120eeb4ea649ccc698d728df159c0e459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0217faab07daadaa64df333dfefd585481c6d2bc0030cd4909166751f8dabe28"
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
