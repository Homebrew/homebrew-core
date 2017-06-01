class AmmoniteReplAT211 < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/0.8.2/2.11-0.8.2", :using => :nounzip
  sha256 "390bd4e8d1c443b3ce66096b9125dbc4f4aa7486a898617a52d2a2654fea6cd2"

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
