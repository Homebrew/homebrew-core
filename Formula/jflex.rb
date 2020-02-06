class Jflex < Formula
  desc "Lexical analyzer generator for Java, written in Java"
  homepage "https://jflex.de/"
  url "https://jflex.de/release/jflex-1.7.0.zip"
  sha256 "833ea6371a4b5ee16023f328fbf7babd41a71e93155cf869c53f3ff670508107"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    pkgshare.install "examples"
    libexec.install "lib/jflex-full-#{version}.jar" => "jflex-#{version}.jar"
    (bin/"jflex").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/jflex-#{version}.jar" "$@"
    EOS
  end

  test do
    system bin/"jflex", "-d", testpath, pkgshare/"examples/java/java.flex"
    assert_match /public static void/, (testpath/"Scanner.java").read
  end
end
