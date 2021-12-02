class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.0.6.tar.gz"
  sha256 "1d932828cc7758a775e413abfe20d4f20d48b58fccbfbdb688abfeec70bbb7bc"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1796bad1a01c213aa8d8b3c67884da2d660ad92bdaa5f7fc7e6d0fbd46a8b83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b1d7ff69012a0d5b266966b0a72593fd23164a9229409ba8c57b7aad1b3dcf7"
    sha256 cellar: :any_skip_relocation, monterey:       "a4913982c2d0bbf48c8826389d60a3f573e7d3dd986f953c62e0d32e4a6abe71"
    sha256 cellar: :any_skip_relocation, big_sur:        "21043ec55dfbec0c9e5e3b31130f68200b153fed6e03122e3db67927381bd9de"
    sha256 cellar: :any_skip_relocation, catalina:       "341bb504c1fe3c575a4146d11c980cbfa1f855706cde404bff3434a14bbf7954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "537f63575b5c554eb171463a8fb44025f768cd154c6958cf2285a4b67a474bb2"
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
