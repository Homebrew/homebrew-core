class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.29.0.tar.gz"
  sha256 "113a26739dc70925e747704258cff91d5b74786bd460c7315b1e15a4b0402e8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cd844fafc6c7f6000c0302530d926cc6aec778f376529a9bff81696ca5397c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc8325c19d41348533a428bf2ee15a4048cbe60517d3f6a02b3cf54bef6f69fa"
    sha256 cellar: :any_skip_relocation, monterey:       "b96feb23ae8d0fa0020ad822e0bd3f4a87a776b2856e8b2705efc61a5781a04d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bc9139830ee9d84dccb6e0c78d2842f2004ce37d992fd4dfdf4556d9b54a075"
    sha256 cellar: :any_skip_relocation, catalina:       "035845a2b2719b0dbb537e5c310cae3c6ecfbaeae96918a75b55d8a44b7c7c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d0cfb1200f129f4b9bd3f661af5f0a93ece8762f1761abf24ba35ea94062e8d"
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
