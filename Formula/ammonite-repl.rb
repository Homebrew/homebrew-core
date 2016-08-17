class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/0.7.3/0.7.3", :using => :nounzip
  sha256 "3942d850a906234beb0eca1d04f9de9b1b7dd36869ce65b969b4b7e627478395"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    bin.install Dir["*"].shift => "amm"
  end

  test do
    ENV.java_cache
    output = shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
    assert_equal "hello world!", output
  end
end
