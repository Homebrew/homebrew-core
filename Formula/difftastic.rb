class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.29.1.tar.gz"
  sha256 "d5db9a1af0abd2c836ed2e61752935fea4dbd2e2ef7cf988217a410fe6cfae3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70f081f034d3a120e617d8a2d43432e048172a7f3e2ae93e9e2e4e308247c0c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b0a7cb4784c7c26c86dbdb3678160e5e8a63bad29fbe72c3d1301255a620807"
    sha256 cellar: :any_skip_relocation, monterey:       "3d7811db2a3b41e721f3ac39532491948603ae3a02d529f5d118b65990e2cd29"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4acfd2376e098ec752973bb75eb19e0edd9c25ec45e8f2984998ba2cf69b027"
    sha256 cellar: :any_skip_relocation, catalina:       "eb5c88349668d63f7afbb593b403de64ae8f42626bd5d77e4e8f87a550716d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee74de401379880f4ac520cd9c82af472026e9ea8f3902b71170e01b1ab91448"
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
