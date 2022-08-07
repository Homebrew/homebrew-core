class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.10.0.tar.gz"
  sha256 "09a35f674e00575724251744902a362e856119ac82cbc170b9c97d26a5f3fafb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c205730613013d075c53781b4df16fef70f569fdfaf3d41d84ee72e4cb341d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcaa053872224069c1ce838bd5abc5227046d684753419fefc16c90e505da871"
    sha256 cellar: :any_skip_relocation, monterey:       "77ae7072ee56ad706c5f22c7085d09d0d683fe318b83e9a93a8cf954ba5bd707"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e299c503b3883795545ef05c2a341da57937d2de2938b900f3d3e436040ba66"
    sha256 cellar: :any_skip_relocation, catalina:       "0d3ae28ed11b55ed72a0377ab0913cc392779b2d305200544980eacc0c227f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0b1b29b893b7a3b7e3f6974dee84b6092248c989378b2cac34ff9a1a221f638"
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
