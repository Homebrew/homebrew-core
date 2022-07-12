class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.31.0.tar.gz"
  sha256 "0f6370aef09eed8cfd03add1b347dc2c3b84009493af7cbcf3ee5c12935cdac7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a555ba64094f30a9ec2e1f921cb89e7625b428f9c9ef9cae27266e5b41d4b5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6bfce3cf030d87b3ce157ab1c542429c48ba7f2b6159106ff7a0c9e9f2cd0c8"
    sha256 cellar: :any_skip_relocation, monterey:       "6a6a8e9f7263207dbb0924b8a49e8220a182e9ca0c5d46d984ab8a8943d24684"
    sha256 cellar: :any_skip_relocation, big_sur:        "758cff91a2dd4a1b8dde113ffc18dfdca7002a152ac1ffe72e7cfc85dad391c6"
    sha256 cellar: :any_skip_relocation, catalina:       "225382e5677fb530499f975f63189da5ef1fe388b858b052754baf6fefebb579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "225a451d09d06ce4d1e5ef333a5ee9a679771d70c04a66318cfced32fdac6cb9"
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
