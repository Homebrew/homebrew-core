class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.io"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.24/htmlcleaner-2.24-src.zip"
  sha256 "ee476c1f31eabcbd56c174ec482910e1b19907ad3e57dff9a4d0a2f456c9cd42"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a7e7c9daa84d81c700790660a2d43400bfab987aae3aa95eb244d36e500961b" => :catalina
    sha256 "32204eab6692433aa9901a20781d15b99a494a25d99dd22357944f4297e77ef0" => :mojave
    sha256 "70e509e98f352819e0dc4bdbe125f74ffcc4e80f660515f4cb59e3cdbaa3f273" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on java: "1.8"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.safe_popen_read(cmd).chomp

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
