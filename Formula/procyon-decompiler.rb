class ProcyonDecompiler < Formula
  desc "Modern decompiler for Java 5 and beyond"
  homepage "https://github.com/mstrobel/procyon"
  url "https://github.com/mstrobel/procyon/releases/download/0.6-prerelease/procyon-decompiler-0.6-prerelease.jar"
  sha256 "781556282a3c71c013fd3f47823c5408d1731b2ce87dcf4c6f2a7495d526add9"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "procyon-decompiler-#{version}release.jar" => "procyon-decompiler-#{version}.jar"
    (bin/"procyon-decompiler").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/procyon-decompiler-#{version}.jar" "$@"
    EOS
  end

  test do
    fixture = <<~EOS
      class T
      {
          public static void main(final String[] array) {
              System.out.println("Hello World!");
          }
      }
    EOS
    (testpath/"T.java").write fixture
    system "#{Formula["openjdk"].bin}/javac", "T.java"
    fixture.match pipe_output("#{bin}/procyon-decompiler", "T.class")
  end
end
