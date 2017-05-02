class AmmoniteReplScala211 < Formula
  desc "cleanroom re-implementation of the Scala 2.10 REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/0.5.7/ammonite-repl-0.5.7-2.10.5", :using => :nounzip
  version "0.5.7"
  sha256 "9f8e67466f58f6490c2d4b4d0f4ff9ad555ce29909843ba63f5c7533b993642b"

  depends_on :java => "1.7+"

  def install
    bin.install "ammonite-repl-0.5.7-2.10.5" => "amm211"
  end

  test do
    ENV.java_cache
    assert_equal "hello world!", shell_output("#{bin}/amm211 -c 'print(\"hello world!\")'")
  end
end
