class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.41.0.tar.gz"
  sha256 "2dfb85b86fbde11976c83ff057610bd9fc2ebe3b8dc99d1ecaff28231e13cf45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03b904a0779d45e0a1e5b800d33ba2c565fd086faf08fdf9b8c0021ec809b1dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9580fc0dde8197326112b891a50d765ba29a7b0505aa1d51e1cc32f0b15c8af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92e5027a2f6814f49df3832e340926cbee6c9372cfd6976307fe8bb2af73dc89"
    sha256 cellar: :any_skip_relocation, ventura:        "227c83bb473ef343711ca45dc43415c12546a4a886214950cd200d277cdffc5b"
    sha256 cellar: :any_skip_relocation, monterey:       "3af4cff1c154a43aa03fd85a3b5ce893577316422bb1fab7adaddc7fa54d0525"
    sha256 cellar: :any_skip_relocation, big_sur:        "a691ee98dc55e07a022e47616bd8ec8a506813a585d2b21691bc49b974c4fc55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0d28821b5efae61765f0042af774ae353ca6935262f64bcb16acb93c6163bff"
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
