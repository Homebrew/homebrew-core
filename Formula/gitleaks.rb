class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.8.9.tar.gz"
  sha256 "6d3d51bcb273920b39cc5bc68b577e3edadfcf0130e0ad3b41bb9081480b0274"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09bba3bbd845b934582a562003357a4af45bfba73238a5ec31c230ae4ea505b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b991cb2942191f2b5c98ea560d843ecb54c8c62a32e02ce6178dcba412364f14"
    sha256 cellar: :any_skip_relocation, monterey:       "58d367f70be6c017bde633cb76e34e5508cdaf02fa8255a14442e0d538f3896b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6120d8895aff7f9c08da174bb8366638eaad1b193b2c319b84dcbab38a5ce0d4"
    sha256 cellar: :any_skip_relocation, catalina:       "5957a47773bc94819b264c00df4ce2abd527480437aafea8c52a0dcc6af7dc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "627ff93f0f4ec7bd9baf39c16c18b7272ff239d01b120d9370c4fe5c27da9eac"
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
