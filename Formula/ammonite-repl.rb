class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://ammonite.io/"
  # Prefer 2.13-x.xx versions, until significant regression in 3.0-x.xx is resolved
  # See https://github.com/com-lihaoyi/Ammonite/issues/1190
  url "https://github.com/com-lihaoyi/Ammonite/releases/download/2.5.6/2.13-2.5.6"
  version "2.5.6"
  sha256 "365cf83befaa147972510eee4ee736b28c648ac632d8e30ca9b9cfa0515e2e45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ededf27e950a878fd83ee62d261c778dcfc9ba14c3876cd26feab55ec5fd3f52"
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
