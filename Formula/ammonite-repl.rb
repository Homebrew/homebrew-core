class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/0.8.0/0.8.0", :using => :nounzip
  sha256 "fb643fc0f9dcabd0ec0206c6c63346dcf6b88f2830da940ed2ed476f41ba4790"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    bin.install Dir["*"].shift => "amm"
  end

  test do
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{testpath}"
    output = shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
    assert_equal "hello world!", output.lines.last
  end
end
