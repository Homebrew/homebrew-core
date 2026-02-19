class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://ammonite.io/"
  url "https://github.com/com-lihaoyi/Ammonite/releases/download/3.0.8/3.3-3.0.8"
  version "3.0.8"
  sha256 "f78dfe9606dc2cf7345b5afa068f51f3b72e0544ed371b3804700b584a0ec11e"
  license "MIT"

  # There can be a gap between when a GitHub release is created and when the
  # release assets are uploaded, so the `GithubLatest` strategy isn't
  # sufficient here. This checks GitHub asset URLs on the homepage, as it
  # doesn't appear to be updated until the release assets are available.
  livecheck do
    url :homepage
    regex(%r{href=.*?/releases/download/v?(\d+(?:\.\d+)+(?:[._-]M\d+)?)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "929f5c5de34d8b0a31cb972a256fdf47c813360d965c42f9cb142fda4078573b"
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
    (testpath/"testscript.sc").write <<~SCALA
      #!/usr/bin/env amm
      @main
      def fn(): Unit = println("hello world!")
    SCALA
    output = shell_output("#{bin}/amm #{testpath}/testscript.sc")
    assert_equal "hello world!", output.lines.last.chomp
  end
end
