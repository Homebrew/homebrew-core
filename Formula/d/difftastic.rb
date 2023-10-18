class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.52.0.tar.gz"
  sha256 "6d7136be4172ef7b1c4d9af50a54a620beae57670a71622fe91e55090be97065"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ec0abdfd067cc0607190cc6e72cfea22aff3b443762c3bdca1e4c36b8448b37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea658e624fa21f53c824d946ec7a1056f59def8239608608e6103ea7d1b33dd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f75219eaf917a342e25c6d62e4ae340a03e2c271e27112a597fbd1824cf2780e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7787c0f7e00999f847376faa19e5d4b297669357109114859e508a2ed7f4589b"
    sha256 cellar: :any_skip_relocation, ventura:        "c7e8d4162c09477922e50f1596c40275cbd96ec476e8fc92e632c853211b655d"
    sha256 cellar: :any_skip_relocation, monterey:       "a9d3e08fc01ae495b33f085f79fa678d7d4057dd5413d6cef7205ff33c6aad42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "710d56f4d1fad41ad639bde3e653408b76340b2cc17056dc366df2b89c40ba4a"
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
