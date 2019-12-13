class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/1.8.2/2.13-1.8.2"
  sha256 "2d13aee7a29366f6a56ec8c1f9b46d0fd586a8c0327c9bb7789042328400005c"
  revision 1

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
