class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.io"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.24/htmlcleaner-2.24-src.zip"
  sha256 "ee476c1f31eabcbd56c174ec482910e1b19907ad3e57dff9a4d0a2f456c9cd42"

  bottle do
    cellar :any_skip_relocation
    sha256 "6038a9e1da250fc5ba2dce5f78f008e2c2c1b70cf5298c9f27680f0b9f0ffb46" => :catalina
    sha256 "8155f0e07b26a7c16ddbbcd29bf196f4822076972441ca4521be9efcd8677bf3" => :mojave
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
