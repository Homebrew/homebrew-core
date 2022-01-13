class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://ammonite.io/"
  # Prefer 2.13-x.xx versions, until significant regression in 3.0-x.xx is resolved
  # See https://github.com/com-lihaoyi/Ammonite/issues/1190
  url "https://github.com/lihaoyi/Ammonite/releases/download/2.5.1/2.13-2.5.1"
  version "2.5.1"
  sha256 "aeaf122ed8f4adbdf9bdcbcfb02ce10c647ddc48c7a14e8a021123b3658803aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec600c57628b4766be554b17265751691c82a7905fc68fd1a12520defda7555f"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install Dir["*"].first => "amm"
    chmod 0755, libexec/"bin/amm"
    (bin/"amm").write_env_script libexec/"bin/amm", Language::Java.overridable_java_home_env
  end

  # This test demonstrates the bug on 3.0-x.xx versions
  # If/when it passes there, it should be safe to upgrade again
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
