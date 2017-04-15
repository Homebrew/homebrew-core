class AmmoniteReplAT210 < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/0.8.2/2.10-0.8.2", :using => :nounzip
  sha256 "b612e4c642b29dc1b7f652e2150383fe9fa2f57300b7751837bf6150dd32bad0"

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
