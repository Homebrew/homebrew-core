class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.io"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.21/htmlcleaner-2.21-src.zip"
  sha256 "7b88e37b642170ef225eba380a97999d97dc84650f0ecb14ffed6fcf1d16c4a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "9cd554397a9f87a8862466135f1c25968b6f03220e19eccc4d736d339f899423" => :high_sierra
    sha256 "68276e2d39776358c4fae2bf77dc09861bed0bb9a8a97fa9f490c060fc50db60" => :sierra
    sha256 "888335b4c91925434e794ad53483983e7087060cf6143fa2f69deadb6949f04a" => :el_capitan
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    system "mvn", "--log-file", "build-output.log", "clean", "package"
    libexec.install Dir["target/htmlcleaner-*.jar"]

    (bin/"htmlcleaner").write <<~EOS
      #!/bin/bash
      export JAVA_HOME=$(#{cmd})
      exec java  -jar #{libexec}/htmlcleaner-#{version}.jar "$@"
    EOS
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end
