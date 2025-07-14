class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.64.0.tar.gz"
  sha256 "54c7c93309ff9a2cbe87153ac1d16e80bacac4042c80f6b7206e9b71a6f10d0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "293cd86f9d63611d356a2a8de36b73363171658c73ae90582496ad6c685fbad4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9afc0d4ba3e5d89117b020f7ed875e5ea98b1c75e293e11383ccf94dcefc8425"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8388f82f3f4e41178ecc084fbde904bee0040ff4d67ded460bcdfc7fc1383b8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "82bdbf54e418d81749a3f83f9390bfdbbf2b8e12ba9e23eb6d8ee56ce6847d86"
    sha256 cellar: :any_skip_relocation, ventura:       "c764371b59c9e7037f8d596ad85ec1561c32c8b94b7902cdb8282a2087f99c65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2f793803c82dd9d28c3981f9e21907ae2ab31233405910811852c4f0d02eb8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ed84db027e1ea11b60b7b5fc9c86f41e476ac3faeb58b27fb60d0cc2f4f52f7"
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
