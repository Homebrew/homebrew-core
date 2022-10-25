class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.3.2.tar.gz"
  sha256 "3767e39099a29bda54f31b33dd41611ca051d7323b1c80fdc477c4c8b2a720a4"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b417a4aaf505b3fbd8d612cb9f1603e89f5a38640f6dbe2a0492af4e678b5914"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "981ffe9981bb26c3e91966aa67f583393b5d51c8cf2a7a6e41db4a7bc6fc4b14"
    sha256 cellar: :any_skip_relocation, monterey:       "2f6fda13209b0790cfc187c6ec8b73c3b19126abcfa7b6aa3a594c21537551e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e8c27b1844d7bd49aadc707751272236cba6958a32a74992e26829c5737c47a"
    sha256 cellar: :any_skip_relocation, catalina:       "c29285e625e205dfe0d224663e8c62daa5cb692949d5d056d2f42c808384c0c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fcbeec18acc94936b63c835ce0b18be7917da24a5d6668a410be3a6b13183b7"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
