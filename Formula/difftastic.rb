class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.37.0.tar.gz"
  sha256 "a49a329bcde18574e8152b055d5bbd2a10aa9c8492ca677fbf8963fad3220949"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e46a0f1857fc402f126520630a90eabeb63ee32b2b15b996281e17a1072b5186"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38a339a9a7bfce03d999057c198e633a6ba2b02927f6b8124fcffe1825c5a0b5"
    sha256 cellar: :any_skip_relocation, monterey:       "595abd22d0496e3f5e9ffdf8e6c189403ba3c3fb71944b4538ce85b80852b075"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dd37754dd9d15c364253a620332ad366799a70369d892e528efd61ef6cf55cd"
    sha256 cellar: :any_skip_relocation, catalina:       "3cacc2f3be2da699278d2e83c0c5efdb73546e6047b0c0643e779c89d320fd79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42ca32e3f05b4d6ecd17220da7f5e71581a6847027f0f3bc45053bc13783ec2b"
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
