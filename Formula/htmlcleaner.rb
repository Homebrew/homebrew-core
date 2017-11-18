class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.io"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.21/htmlcleaner-2.21-src.zip"
  sha256 "7b88e37b642170ef225eba380a97999d97dc84650f0ecb14ffed6fcf1d16c4a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "3151b50796233ec0632ce0cb481d7a2960ff6858672c0c8b11766641d0e0004a" => :high_sierra
    sha256 "87838ab8f3acda2911416178fd1bdf11d37ac7d3b6e21007f6218d1ad7e7139b" => :sierra
    sha256 "cc0afb1dd3c56cd78700138590142baa370480ff979ff757a4b5f7a18f66219c" => :el_capitan
    sha256 "2082bbebc107e771ed502971cec401c9b23b5c977c2fcc9324cd54c28f78f5a8" => :yosemite
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
