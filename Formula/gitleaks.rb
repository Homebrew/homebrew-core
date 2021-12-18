class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.2.3.tar.gz"
  sha256 "17c183534da82edc54fc07b15078bf0a8a6a3259ffd24d5d48e8a8b865538671"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95cb7979d1b3f46d6298168b0787f4517bcb3ed75c104a91f1143fc698007b21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1355672136e515ba5bc0dc6a1530379b0e185bb2bc7604dccd64e3807e2010e9"
    sha256 cellar: :any_skip_relocation, monterey:       "8fc9139e2c61690d10eb7347c15ccb44b659dc3233e6f4787253d45212d89707"
    sha256 cellar: :any_skip_relocation, big_sur:        "58bd365bde6a39bc0c1b9b20eb7b54abfc9d4720f2dcabaab30ea8b0eab1aaa9"
    sha256 cellar: :any_skip_relocation, catalina:       "a3e0a94de48b2e54a0c0a5e966ca6ddf391330142ce48ac8b6f5646aaa04672b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8751bc638fec0727926223861b6c6cb61fdcd9078ddfd9ae11f624269a670158"
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
