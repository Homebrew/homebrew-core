class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.8.6.tar.gz"
  sha256 "2fddff2b940324c34e52709f9d2e6dc00471f301d4c8e2b4317c3b21103e251f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7919bd46babd12f5c9ec06b7822935f3bdb2eb3bb4b25a27afc6d1352571910"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e298c1a20632884532d95cb2db4176597caedbc2343295eff8cff9047c10a36f"
    sha256 cellar: :any_skip_relocation, monterey:       "81ea1b9ee3619910a0e3bb2ec0cca731bb2ec5c3d202b3851d8f54e53e5d5424"
    sha256 cellar: :any_skip_relocation, big_sur:        "b668aebda72031e428fea36b702ebde74457376ed60834c6e06c015b25ec8f56"
    sha256 cellar: :any_skip_relocation, catalina:       "96084f5061b5d0fab2f4ebb7d4165ed4b05c036a60c18d48a4fe8706c5d51116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06df6b927396480b2e9929e78b452320177ecf9b38d1bd5bd363565ad7c6b6d9"
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
