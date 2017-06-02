class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/0.9.6/2.12-0.9.6", :using => :nounzip
  sha256 "58d29823395e448945086cf056d5bed490f7de4ad27191892395561345447084"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    bin.install Dir["*"].shift => "amm"
  end

  test do
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{testpath}"
    output = shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
    assert_equal "hello world!", output.lines.last
  end
end
