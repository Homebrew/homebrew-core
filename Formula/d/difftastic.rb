class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.62.0.tar.gz"
  sha256 "ef69a23c6e3b9697d84ea5be158e8cb6d7482f49fc91cf4f9c7416bd48301260"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d96104e5f2273ad8eecfaa925654deb484cb91ef3ce4a45822b9682ca503dc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "459d4b9a107b05f5061d08211df5c70fe80ea9691b2a47d8dd07f0f68bfe6920"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7efdc69371102eecb52adbe6a37d52e8dbcfe8a198f06f499b8f0fae3838ca66"
    sha256 cellar: :any_skip_relocation, sonoma:        "838656dcc64c0545adcf44d781e8f6223c783dfd414fe498725d2e501a0135b3"
    sha256 cellar: :any_skip_relocation, ventura:       "f617037ecc7099347323b2fffa87505664c6b84f07ebcd9bcc3b148f2ee72935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e32986d6d64e1c25f3a97c62c24fd1ea83c35c83a69f19ceb1855c41a4f6d162"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "difft.1"
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                   1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
