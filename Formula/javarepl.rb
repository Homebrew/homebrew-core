class Javarepl < Formula
  desc "Read Eval Print Loop (REPL) for Java"
  homepage "https://github.com/albertlatacz/java-repl"
  url "https://github.com/albertlatacz/java-repl/releases/download/428/javarepl-428.jar"
  sha256 "d42de9405aa69ea6c4eb0e28a6b3cb09e3bd008649d9ac6c55a4aa798e284734"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8dfb5aa35857100594bac67ad0fe445030f8a2725e004d0305e589c1ed08e01c"
  end

  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

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
