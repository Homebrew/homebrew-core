class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.26.0.tar.gz"
  sha256 "a224838b3802c876aa8bd8247d882ada98929c9ef41dba238b8d4e6ce3f419c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60ea20f8edade077fd37a414f40a139d7048f57d13e4d5697b9633c203a2d044"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cda6f8b754749e8832e2a6bae43591c4814ebeac2c70399414c88303a23f421"
    sha256 cellar: :any_skip_relocation, monterey:       "b2fa62227880e826ffd741e8e82aeb936bdf4a8c8984bf2bf24b1ba46193780c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f48136ca6f7d8684e66487244845250e0910082f480477759c9f3e926cbd1c4"
    sha256 cellar: :any_skip_relocation, catalina:       "7ba3b2d5f1ab590bf16716200b89415e2c4345f4f56b7c47ace42064fdff71ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3200952bdc22cb91a6a01ddc996435e94dcd9dd1e7239e580ce8767b540c1b30"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "gcc"
  end

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
