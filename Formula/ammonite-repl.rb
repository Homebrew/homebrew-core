class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/1.6.0/2.12-1.6.0"
  sha256 "1e93ce4284a71c309c19f4a0a3343e9a110f71ae8877938f940c22128bbe869d"

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
