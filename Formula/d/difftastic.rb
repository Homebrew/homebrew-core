class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.57.0.tar.gz"
  sha256 "7ecc69f9cfa88259f7d6aef9309b03d00db8d2bf314c71807fe8b4f07a386063"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53326f612058d739a8c06d9335382585fbfd8876c4398782666d48fdb1c6a979"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b46825dbf884eb30eeb51b5db779e8dd26cd22dabf0f5f39b4e423453fea5de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b353daf350de309a64fc205b9eae76cc1dc68b517771c00ba4c8a57f9cb08cd6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5e504ec9079ea4647ab556182e1fd6841980a2b22af912d72910477de123a89"
    sha256 cellar: :any_skip_relocation, ventura:        "12427851b7f13656cc2b09c809f12d4e6a3f3a77ecf609728e686ef1f6be459a"
    sha256 cellar: :any_skip_relocation, monterey:       "8257a39114542742673283d0c18a07599691f459ad9e5e4d479c728a1fabb3b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84c5360a3ac13579be79a1c5f409e9c58d50397ca4c63a2b63d080537192600f"
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
