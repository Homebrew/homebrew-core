class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.3.1.tar.gz"
  sha256 "7e57b002fe6eee35b8cf479826efda0e83858679a4510e05bba2a02b9acad373"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1484c5614f73a5aea708e349fd1f35a7d993292f4b17603d7712cabc9f8c9bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b64d24c08004cd8dfbca2d5748392f9eab0bb9601e9c92718a199bab23d0fd76"
    sha256 cellar: :any_skip_relocation, monterey:       "55d8353dd5a7fa5cc5da4fa6073fb913e2385598bbac0f4f413c7e740949655a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ce37c174ec8f1f28926c92b3ca048419e6445db7e80ca889ef04e7e5a32a084"
    sha256 cellar: :any_skip_relocation, catalina:       "54ec4f6ef3e83838f5ad3070c9eb702c43f434572556387c2224d7ee66dad1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "451b18cd3d66abd89a30709986737c5d077c1f2db6881ed48e48280e185cd017"
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
