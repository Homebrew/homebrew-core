class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.56.1.tar.gz"
  sha256 "54e4f3326be3c8fdd2263fd3ac9b31ea114c3c8d03efa6b928de33515ac41f24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f987dbc0a5f405db1d7faa0d46c622105e088dd58f7a32a73c6bab7d557c715d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "803efde75a997b91c6793eed357b39291cd181adacd1d5dfe98993ed01543808"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdda722cf2ad2aa7e5e7c3e9b819859c58db3bd95d90cc798f470db0756960d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "291253ab927da309bfd40e60af1585369ea9ecc3fccb598db2af90de1d9ca67f"
    sha256 cellar: :any_skip_relocation, ventura:        "bb88a1200330d0ddb2684bce43217b6c61f6577a79f02ff53dc7035a6b54a006"
    sha256 cellar: :any_skip_relocation, monterey:       "b965d0f8c8ebd2e7ddb4aa23f9b00ec68a6c1cfa61e8d67ff810921d794812cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0b6949461e53b2b67d2b3953084a8e2ccf610222c05323668e73f678aa1eb5b"
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
