class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.68.0.tar.gz"
  sha256 "86cfd4232f99c5dac56bd1e6fab7b8d96cfaac7a4271738b50c8189031c97a66"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cb4cfa55f76562ec113c42d0888214947ded6b18f074581dd0132216c63614f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de19cbc9e6cc0ce15766b211ab3a5084f94deefbdf27606de46fa4bc4a8f07d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f196484d5d6023cc080488c23ee0d8b469e60b056b6f0a89748f8ac0c6285444"
    sha256 cellar: :any_skip_relocation, sonoma:        "2330a5484d1187c7636c1906b2ed9a791d0bb127bc67cc6ff8b253a788c38678"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1866e72a4eaab65074ce7722db03395d9deb540c697b5a8fa9168e4b3113c9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84a7520661017cfa7c67e20c3149745a314c87bc6ec481dd58686b189e5c56e8"
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
      1 print(42)                  1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
