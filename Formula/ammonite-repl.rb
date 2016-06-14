class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/0.6.1/ammonite-repl-0.6.1-2.11.8", :using => :nounzip
  version "0.6.1"
  sha256 "91bccfac8cec31cff330c85d091be8d7ffd9c4d35c9faee4237454f152b49bf0"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    bin.install "ammonite-repl-0.6.1-2.11.8" => "amm"
  end

  test do
    ENV.java_cache
    assert_equal "hello world!", shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
  end
end
