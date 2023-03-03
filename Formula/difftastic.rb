class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.45.0.tar.gz"
  sha256 "8c4cc0ad50800d6e5705d768e2ad1a32ac0a4a44318102fd8c1198a59422992b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd6e70b06c4c13c06382da960cf302fa7d913151083052d7ec9f6a15c9d2237d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03bd97c4f11459a25132bed4cb2c5e3bdb55fcfbd03ccf53523e9983eda9a34f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "427655c589824f8203c018710140e6c0ed0f69c0234de0d35a80ec00cdf69804"
    sha256 cellar: :any_skip_relocation, ventura:        "0cfc5d0c33a034dd8369e323ecdcb1211327615b67629f77a3d8af62aa2c03cc"
    sha256 cellar: :any_skip_relocation, monterey:       "cbd51f50fac6a3df0f7f3e0e9f670d91a095bd07a063a1dda0c0332b6772e25c"
    sha256 cellar: :any_skip_relocation, big_sur:        "131d0635ff6cdd6289210d0e0581a6093d23078d86a5cf59efc4258e31bedc26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ca44080adf4c6a6d4f2d16ef862458e2edb64b4c268237ea02981068b69d038"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
