class Javarepl < Formula
  desc "Read Eval Print Loop (REPL) for Java"
  homepage "https://github.com/albertlatacz/java-repl"
  url "https://github.com/albertlatacz/java-repl/releases/download/423/javarepl-423.jar"
  sha256 "24b89daf955b6bad61c8955ae4f8a5447514c5e92b216d9eff3e0b1f54abf0e3"

  bottle :unneeded

  def install
    libexec.install "javarepl-#{version}.jar"
    bin.write_jar_script libexec/"javarepl-#{version}.jar", "javarepl"
  end

  test do
    assert_match "65536", pipe_output("#{bin}/javarepl", "System.out.println(64*1024)\n:quit\n")
  end
end
