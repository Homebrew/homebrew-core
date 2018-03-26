class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/1.1.0/2.12-1.1.0", :using => :nounzip
  sha256 "d448fb8b846cddb0315e5cda03036a73427f2c7335f76faed75f61eb5ce0a537"

  bottle :unneeded

  # Upstream issue from 2 Aug 2017 "amm throws NPE on OpenJDK 9"
  # See https://github.com/lihaoyi/Ammonite/issues/675
  depends_on :java => "1.8"

  def install
    libexec.install Dir["*"].shift => "amm"
    chmod 0555, libexec/"amm"
    (bin/"amm").write_env_script libexec/"amm", Language::Java.java_home_env("1.8")
  end

  test do
    output = shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
    assert_equal "hello world!", output.lines.last
  end
end
