class Javarepl < Formula
  desc "Read Eval Print Loop (REPL) for Java"
  homepage "https://github.com/albertlatacz/java-repl"
  url "https://s3.amazonaws.com/albertlatacz.published/repo/javarepl/javarepl/350/javarepl-350.jar"
  sha256 "82fa4144c8863b5dd441fc6a5dd7d8f6191a7de94406e1de5c6d1a08f992140a"

  bottle :unneeded

  def install
    libexec.install "javarepl-#{version}.jar"
    bin.write_jar_script libexec/"javarepl-#{version}.jar", "javarepl"
  end

  test do
    assert_match "65536", pipe_output("#{bin}/javarepl", "System.out.println(64*1024)\n:quit\n")
  end
end
