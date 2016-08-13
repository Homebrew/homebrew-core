class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/0.7.0/0.7.0", :using => :nounzip
  sha256 "bcd86bee82b63f11bd4ae8b3c72b90401f3183b09f586326aeb6743f4c78f918"

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
