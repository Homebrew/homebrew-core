class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://ammonite.io/"
  # TODO: Check if we can use unversioned `openjdk` (or `openjdk@21`) at version bump.
  url "https://github.com/com-lihaoyi/Ammonite/releases/download/2.5.9/3.2-2.5.9"
  version "2.5.9"
  sha256 "46526cf213b29328c4bb64b4c27f701b25aff7ccb0f0d0336871fbddb4a3714e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3e9cb15604ec2bc9038ce20600af80f8234dac7a51df7f812f7a108068684da3"
  end

  depends_on "openjdk@17"

  def install
    (libexec/"bin").install Dir["*"].first => "amm"
    chmod 0755, libexec/"bin/amm"
    env = Language::Java.overridable_java_home_env("17")
    env["PATH"] = "$PATH:$JAVA_HOME/bin"
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
