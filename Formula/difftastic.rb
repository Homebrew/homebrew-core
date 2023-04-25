class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.46.0.tar.gz"
  sha256 "bab9b893f6f6476aefd2a3dd9298cadc70bcdae57d4de03a651574d7145228a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79a692be0cb92ea1ae46cd1b8889a883c16f120c588d5b2bb754615f4606e7e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25afebb1e453c132706783abae3fd77e8200900ef54607868510b134d67ffc37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37f96864f9b613a41f74fcdec8b5c115674482c17194ab4aa237eea8c9312b62"
    sha256 cellar: :any_skip_relocation, ventura:        "532d9b250bdfcff7d7c71d874c18eb34832e8593431dbbd915ef502e2e452de6"
    sha256 cellar: :any_skip_relocation, monterey:       "5dd8b3df993ce44b5c1e1abc2015936934b7b68d7ad8fbc12eacbf5c0f76a52a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2e99e2c02521ca0d85863c888e8409d96cbd87f1d75c7af13bfed238a91d7db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8c9c3a7bfb9a1749f5965a07adcf76c3638f3b261bc54c7ad448269f0c55c88"
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
