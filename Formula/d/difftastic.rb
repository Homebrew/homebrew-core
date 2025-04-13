class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.63.0.tar.gz"
  sha256 "f96bcf4fc961921d52cd9fe5aa94017924abde3d5a3b5a4727b103e9c2d4b416"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44a308c711b145d779e07d65b0d0c8cb676cf28802d09c53293d0f9db3d651cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "460fa7cf4158529052c493abe521d1cfe890eb5a2a47dce1240a7e3e11211a49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7edb10cd62c0a2fd50175e5b11cb0b8f7f20695e91ada25b2df870441bc2d21"
    sha256 cellar: :any_skip_relocation, sonoma:        "102eab4842ecccf93ac8a8c65537a6be6da20d2c1610bd159b8711d3f413f523"
    sha256 cellar: :any_skip_relocation, ventura:       "51536fbe2b7004dbabb491d9b48a1be08f32857f0cff326deb3c6e5799e2b1f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18e486daa9517bd3a97e32d0c3e8ca31bf470d2131d4df3ed11b9371efdb11de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22e2e3aee49400b6c943033f17e56f4a069addc228877b1e33a165a114c93e8a"
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
