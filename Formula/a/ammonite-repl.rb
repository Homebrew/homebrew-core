class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://ammonite.io/"
  # TODO: Check if we can use unversioned `openjdk` (or `openjdk@21`) at version bump.
  url "https://github.com/com-lihaoyi/Ammonite/releases/download/2.5.11/3.2-2.5.11"
  version "2.5.11"
  sha256 "384cf08e2591be4d199c75cf1913d44c043466b8cddeaa21dd5669d10f94a18f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bc3ee73003b1b68cd598d24833dc3ca8ca8ba30dfac338bf5d2e48fe30bf6f4d"
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
