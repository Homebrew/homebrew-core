class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.29.0.tar.gz"
  sha256 "113a26739dc70925e747704258cff91d5b74786bd460c7315b1e15a4b0402e8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95da11d8b816d4b69afa547bf8bc6c3c9049b2dd55daa69fe10695525ea6a0b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2817f31b2eb1f1574ded2db6aa1533b99835da329e9a4dd742e45603b2f126fe"
    sha256 cellar: :any_skip_relocation, monterey:       "725fa8d0db99a3033e74d6135b94b32ef73e68423a42b6af4ad467799c5894f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bde130d5c09bf61aac5e6a70fbd49312601b2ea47a0e6486c1cf904c69fd6a1"
    sha256 cellar: :any_skip_relocation, catalina:       "c5097af85726619d28cde7393c4b51365c91a60715f13d1d0b06ccf33ee14f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15eb8c75bb65d1077768f2a36e0e59fe8d6b1b5813dacccfb61052fa6bb49eed"
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
