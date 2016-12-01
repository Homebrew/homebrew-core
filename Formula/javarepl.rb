class Javarepl < Formula
  desc "Read Eval Print Loop (REPL) for Java"
  homepage "https://github.com/albertlatacz/java-repl"
  url "https://github.com/albertlatacz/java-repl/releases/download/366/javarepl-366.jar"
  sha256 "d9e14503e2b59f04c446b3c247561351a9b1d481ee5ace5cf14e9141a82159a9"

  bottle :unneeded

  def install
    libexec.install "javarepl-#{version}.jar"
    bin.write_jar_script libexec/"javarepl-#{version}.jar", "javarepl"
  end

  test do
    assert_match "65536", pipe_output("#{bin}/javarepl", "System.out.println(64*1024)\n:quit\n")
  end
end
