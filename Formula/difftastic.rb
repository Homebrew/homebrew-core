class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.27.0.tar.gz"
  sha256 "0574d0f3f3b1aab7116cc6a41ff6df8022e93daade0460cded6b16988d58e316"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb1978b2f669f10ea81889e18419300dda2a2952c10b586ab376d7730de12cef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9821e791b25d5f9c4c668f1aa9116aab7c8613ee6c1364deb6536e4ee1cf026f"
    sha256 cellar: :any_skip_relocation, monterey:       "f37f8cb2d88be1baff56064f767a4951f238d9edfc076640eec5e25f7034b860"
    sha256 cellar: :any_skip_relocation, big_sur:        "4167c1a117f569d89b7a5282abdf0f1909cf01c30db9f77e5c3bc53d440c3d4c"
    sha256 cellar: :any_skip_relocation, catalina:       "ca2fcf13c8b67073f7ec532afcbd8bc98c1d8cc74b7fc1837efda38dd2b26dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d647a2eeaa1f99445c4a34e3150dc9eed8f584e5a2f21de7043b75d73938890b"
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
