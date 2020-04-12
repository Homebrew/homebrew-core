class Jflex < Formula
  desc "Lexical analyzer generator for Java, written in Java"
  homepage "https://jflex.de/"
  url "https://jflex.de/release/jflex-1.8.1.tar.gz"
  sha256 "3d9d63f4940f8452885bc63048b8b621a1a3a6e99d406f6d0b8c9f183ee15743"

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
    system bin/"jflex", "-d", testpath, pkgshare/"examples/cup-java/src/main/jflex/java.flex"
    assert_match /public static void/, (testpath/"Scanner.java").read
  end
end
