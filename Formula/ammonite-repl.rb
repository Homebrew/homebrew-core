class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/releases/download/1.0.5/2.12-1.0.5", :using => :nounzip
  sha256 "347d32b85fd93e61005cd76e3e137dbd19068e0cbad6943118657ca5881ac783"

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
