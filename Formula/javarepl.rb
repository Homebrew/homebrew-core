class Javarepl < Formula
  desc "Read Eval Print Loop (REPL) for Java"
  homepage "https://github.com/albertlatacz/java-repl"
  url "https://github.com/albertlatacz/java-repl/releases/download/428/javarepl-428.jar"
  sha256 "d42de9405aa69ea6c4eb0e28a6b3cb09e3bd008649d9ac6c55a4aa798e284734"
  revision 1

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    libexec.install "javarepl-#{version}.jar"
    (libexec/"bin").write_jar_script libexec/"javarepl-#{version}.jar", "javarepl"
    (libexec/"bin/javarepl").chmod 0755
    (bin/"javarepl").write_env_script libexec/"bin/javarepl", Language::Java.java_home_env("1.8")
  end

  test do
    assert_match "65536", pipe_output("#{bin}/javarepl", "System.out.println(64*1024)\n:quit\n")
  end
end
