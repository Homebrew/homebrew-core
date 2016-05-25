class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/0.5.8/ammonite-repl-0.5.8-2.11.8", :using => :nounzip
  version "0.5.8"
  sha256 "1bcaf9eee84d662f8c24396b9b8fa117afc7933c1c8c74d7650b3f358b77ee5b"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    bin.install "ammonite-repl-0.5.8-2.11.8" => "amm"
  end

  test do
    ENV.java_cache
    assert_equal "hello world!", shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
  end
end
