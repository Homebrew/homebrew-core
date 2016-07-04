class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/0.6.2/ammonite-repl-0.6.2-2.11.8", :using => :nounzip
  version "0.6.2"
  sha256 "bd023f4ef27fe318fc5b0d0bf348895b20eb64067b828da034defc28aa98272d"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    bin.install "ammonite-repl-0.6.2-2.11.8" => "amm"
  end

  test do
    ENV.java_cache
    assert_equal "hello world!", shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
  end
end
