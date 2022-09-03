class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.35.0.tar.gz"
  sha256 "dfb800324c7fa329f24fa23b37dbbd63c2069a063d84ae5e7b569c82af7ef9bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "532c384cc0f0e25c88c767e187b2d0c904078997357a9226f720e2bbdce361ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b232524254a2a52bcc32dbef25406c15ef40f628f31c0838b330a38a633be8f"
    sha256 cellar: :any_skip_relocation, monterey:       "17ddbe6ec426ead6225d101c9dceca18f9a934119c77e3b0fde5fa7a3c5f92c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f14aca8bb1b19ffb9d71ac751e5a83ee1b7ebecb53c4c1357090dac1cc72d04"
    sha256 cellar: :any_skip_relocation, catalina:       "efecab4000c0879d5e043a4428b402808c8f6b7ed6fe3695b97d0d60ac67a600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26541db6745fa68a711f1207717c2eae04ef7a859ed4997c8c98936c7e4836bd"
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
      1 print(42) 1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
