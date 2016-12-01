class Javarepl < Formula
  desc "Read Eval Print Loop (REPL) for Java"
  homepage "https://github.com/albertlatacz/java-repl"
  url "https://github.com/albertlatacz/java-repl/releases/download/362/java-repl-362.jar"
  sha256 "069ab1a3d54828a397b28869d695dcbfc27081043aaf89f0125e6094851f8931"

  bottle :unneeded

  def install
    libexec.install "java-repl-#{version}.jar"
    bin.write_jar_script libexec/"javarepl-#{version}.jar", "javarepl"
  end

  test do
    assert_match "65536", pipe_output("#{bin}/javarepl", "System.out.println(64*1024)\n:quit\n")
  end
end
