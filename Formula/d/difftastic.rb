class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.50.0.tar.gz"
  sha256 "20693882580d40a70173fb851aed5d92360040d9b06a821f4b4ffbbc2bf2326a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66c6cf0e3d3f0f59db86e48f7f98d3d8860b8b012899dd6e9b68a6889ec50c8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2e92d1e755d0633b473cb2734f263bcd22cb85f073c6e9772497b3edcf623fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b39b6cbed98c69b048a357f34d32ac7d866b22ea2c271853e746cbfc9341f159"
    sha256 cellar: :any_skip_relocation, ventura:        "bb5c11bc8aa2601caeb1c8f54dbde4c0cb18c05c6ee39ff610de2d129d31f083"
    sha256 cellar: :any_skip_relocation, monterey:       "0b7b87fb45f6dddc96045237ed42bd1d4ea567829e1cf3072ffc2d457f87fb24"
    sha256 cellar: :any_skip_relocation, big_sur:        "006981edf31a711a050d530203b2d24b5f2fdb07d68f272cceeb5f6ff190b267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "739a2500df578ab403727ffeb5996624d3884162a4c56264a92fbc2c0778c355"
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
