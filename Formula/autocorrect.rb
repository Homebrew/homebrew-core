class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.1.1.tar.gz"
  sha256 "1367a2d6f2b8d034d54f0b92498900a6f2ba7b962c3ef374302d968617b3714d"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e886b24c3ffd90b6bbafe5eb39ac070c0fda572b6d0cf4757412c9912c57a3a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c21dd4f3868b72050b5f4a5492f02ab71ea31dfa4ea259230f2f72b6d3083140"
    sha256 cellar: :any_skip_relocation, monterey:       "a0ba33f1db1993ddea44e293c20355e108c433b5ad7474be8edb3ab2dfc31abd"
    sha256 cellar: :any_skip_relocation, big_sur:        "617494de9f82a9f1e35774719b43a79ee22868596180392b5cd3afd929a3e069"
    sha256 cellar: :any_skip_relocation, catalina:       "1a409836ec8644d69c1b4842c3b090484c27a697600e948043cbec12fbd16a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "732655fd8c60f1925636d1f7a411815cd9f9f367e0baf852a991d59cbf194bb7"
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
