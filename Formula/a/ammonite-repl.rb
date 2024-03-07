class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://ammonite.io/"
  url "https://github.com/com-lihaoyi/Ammonite/releases/download/3.0.0-M1/3.3-3.0.0-M1"
  version "3.0.0-M1"
  sha256 "10bf264d499b71eb552153878ddfc9bcef0db179dbdc4b582b6fa2b59c0eb032"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/^v?(\d+(?:\.\d+)+[._-]M\d)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "bb99c7f9610f72dd03b1410868843d71b47d9dec8c5540f7d06f1eed530ad758"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install Dir["*"].first => "amm"
    chmod 0755, libexec/"bin/amm"
    env = Language::Java.overridable_java_home_env
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"amm").write_env_script libexec/"bin/amm", env
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
