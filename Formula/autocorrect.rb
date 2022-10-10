class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.1.0.tar.gz"
  sha256 "f43f8ae2d914bc18a31a4441dacd9013f8abf8984174a82867c6d629e10c23c0"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a9a1f451739f7f4437880a06bc787236a06d6b5bef76075e7fd841d23c83d9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "879ce9fb04e86c42c6ed4e1156a3074bbe16ef6e59f26c30bf0421afe7b35ef5"
    sha256 cellar: :any_skip_relocation, monterey:       "643f85650e6ab4413b9cb58d37b983df2f552018e11bbd19d1c13c71681e32f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4ad98728a2aad3944d782e1c50eef5038efdb5e1e9dc382dc2c991ee4fa0c8b"
    sha256 cellar: :any_skip_relocation, catalina:       "b7e8a5baff18c36d2778466d5aaed79530fd8d51a2c0580433183464bd211f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22c5a0e20a613830d6b725333655b216b7517cd7db6a472bbf39ff24675b08f4"
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
