class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/1.6.6/2.12-1.6.6"
  sha256 "4fa8da2fed0ee25f0ce0c9981284620b41f2599c545e262e75669d823f9a9bf0"

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
