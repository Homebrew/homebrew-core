class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.5.4.tar.gz"
  sha256 "6d06ad99f99aad35400a8cb5bad72eac1496b09953aaa481205ce701a6a3c56d"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6494399d1585147de39f50bb6294276c57f43a0e2b89a04b2d13f020ac78f77c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6cef4f190f27b61e6ec4b530a5271c9fd083badbb7231c387297ab19fcd04e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a61e751f0c9093b19ed085b4050630444c92c4c8c7c25f56eb1104ac0b03eb3"
    sha256 cellar: :any_skip_relocation, ventura:        "50be774d54d63407805676d5794ab29d6e7e815fa049f586c2093b15f8983a27"
    sha256 cellar: :any_skip_relocation, monterey:       "2458fcbd42bf8dfafa72effcb5964922d4516ae8186d195f1900bf282f463190"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e9e08c99758fc5e6dab3e6ee58d17816f3a9e5a73fd069e8256be4862d07190"
    sha256 cellar: :any_skip_relocation, catalina:       "022caaa58c19799b25b5e06ac39b3cc01a0a217df3addbc8a1ca7e2b5129de98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a80841d2c5abc47051b76caa3c3df0e20a71cd7cad27a43ebdc8a86cda13a15c"
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
