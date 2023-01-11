class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://ammonite.io/"
  url "https://github.com/com-lihaoyi/Ammonite/releases/download/2.5.6/3.2-2.5.6"
  version "2.5.6"
  sha256 "afcea3a8155232ce46131af26bfacf0af59754fffa949d4ee2715a90a13be673"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3962c25a280c790dfa3c2c011fafeadab4cfa6a6eff7b7f4ecba520af27676ae"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install Dir["*"].first => "amm"
    chmod 0755, libexec/"bin/amm"
    (bin/"amm").write_env_script libexec/"bin/amm", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"testscript.sc").write <<~EOS
      #!/usr/bin/env amm
      @main
      def fn(): Unit = println("hello world!")
    EOS
    output = shell_output("#{bin}/amm #{testpath}/testscript.sc")
    assert_equal "hello world!", output.lines.last.chomp
  end
end
