class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.37.0.tar.gz"
  sha256 "a49a329bcde18574e8152b055d5bbd2a10aa9c8492ca677fbf8963fad3220949"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c19ded3b145412788776babf782beb5fad2b601343ff7394839e2ad94694477"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fa711223cdce917b9f319e089b71ce55eecd83ac1965eb6c80eeae7ee07ab16"
    sha256 cellar: :any_skip_relocation, monterey:       "9be3205231f8438496016c2c5d681810ec04d85048c4ba67c5d8f384ac3a4dd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "01a6306634570d387dd0e950b5b2d5f65937e2803e675fe59128f75e4720791f"
    sha256 cellar: :any_skip_relocation, catalina:       "025621b5d5e126127f0fc9f4ab7c9292e080f608ef6c32f64d3999ed6cac00f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26169f01d8b892308dfc5a6dc1c1834a7b023ae9e59c52d1a850a6539f2f51d2"
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
