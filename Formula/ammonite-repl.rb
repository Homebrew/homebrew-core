class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://git.io/vVfy5", :using => :nounzip
  version "0.5.7"
  sha256 "ef410dc843391c6b3199f2552a24f5fe3f3c79a7558d813089c8dce8b4ab97b6"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    bin.install "vVfy5" => "amm"
  end

  test do
    ENV.java_cache
    assert_equal "hello world!", shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
  end
end
