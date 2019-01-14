class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/1.6.2/2.12-1.6.2"
  sha256 "148a4057b61fa6ef4c7577a68ffa59321d305fd6ee124a4f1a0d116af30fa22a"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"].shift => "amm"
    chmod 0555, libexec/"amm"
    bin.install_symlink libexec/"amm"
  end

  test do
    output = shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
    assert_equal "hello world!", output.lines.last
  end
end
