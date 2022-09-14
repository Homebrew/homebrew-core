class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.35.0.tar.gz"
  sha256 "dfb800324c7fa329f24fa23b37dbbd63c2069a063d84ae5e7b569c82af7ef9bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f52625d9b43d81265ec224491d31f30d05a15e17bb7fc5dd12c299dc65b8d735"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60296471ddc5e356b8f2890b1379bb792070c6aac178c0e1926594f0c9b4557d"
    sha256 cellar: :any_skip_relocation, monterey:       "2bb54431d18415f31bf674978f5c1ef4af78abb0b00978e4669324a696004a05"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfe2578ca387089770f3aa13c155e8f4c1fca7e1b27212244deecd9f348f7569"
    sha256 cellar: :any_skip_relocation, catalina:       "0378f630c5c4212be42b9361eff5141995dafc0d8f8bb5a6abea672d07a76d7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e022137023d1fc3c5a44fd5da0f78889430455847bf0afc48dd1f340cd640baa"
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
