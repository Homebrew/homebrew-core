class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.36.1.tar.gz"
  sha256 "f7ffd83be50918993669a60821f037af110b809f4cd330ebd59c0b51418a6fa4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee6d2c3696746f34bfe8d3dbadd346adcbe8fbd21c2b87f299b82ff550ed76c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75b36f4a467c5f29aa0ec38f34e2447dfdc1717661884009453258cc9b950b16"
    sha256 cellar: :any_skip_relocation, monterey:       "3e4ad3f3136326c815364b264da914ffc2fb4c1826d11415c216dee5291df307"
    sha256 cellar: :any_skip_relocation, big_sur:        "dda7d642b5f440e971ad76e03850c1499ea9658cc424739fcba82e51538bf775"
    sha256 cellar: :any_skip_relocation, catalina:       "df50ff7cd7d9ebbdddfe14aeb90c675b24ca785efa61717a95cd85345542a916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29eb0bbcfbcd87f3dde68bea9e2dc5cbcacfcb8ea5c0f5bd41f39637dd2358b"
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
      1 print(42) 1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
