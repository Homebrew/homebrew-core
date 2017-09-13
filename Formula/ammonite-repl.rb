class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/1.0.2/2.12-1.0.2", :using => :nounzip
  sha256 "48b78793b824b6ca641d56b525052986c26b53f7f78c2b2e70191f923041b687"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    bin.install Dir["*"].shift => "amm"
  end

  test do
    output = shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
    assert_equal "hello world!", output.lines.last
  end
end
