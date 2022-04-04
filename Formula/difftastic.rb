class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.25.0.tar.gz"
  sha256 "f63ce86ab0b9a2b036b4c61d9601d7046dd79c91be0a0e5a9b3b2a4a7fa66eee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e773ea75d5c13b4d55106976888a6d8126b2a4e09eb0800482fee0d23d52c41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "500bf6742dd567cf61de824f077ecd2a749ff8c3e15502aa25f5d9b76815d6d2"
    sha256 cellar: :any_skip_relocation, monterey:       "9dbb5a46a6a2aab7939d8c9bc5821c0ee109194171dcdb31fa8a52e6c9eb0c32"
    sha256 cellar: :any_skip_relocation, big_sur:        "4084d4863a0028da988d04f61500dc48522e7253c18081c54811b55f08844f20"
    sha256 cellar: :any_skip_relocation, catalina:       "bd530a59b7f15f60946d47a9d3d5592c59c6c751f0c77eed411addedb8706472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baba5779f8a42c5d67d2bca4589a339494982d7575f51b6b0126e18fe15f1d78"
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
      1 print(42)                             1 print(43)                             \n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
