class ProcyonDecompiler < Formula
  desc "Modern decompiler for Java 5 and beyond"
  homepage "https://bitbucket.org/mstrobel/procyon/wiki/Java%20Decompiler"
  url "https://bitbucket.org/mstrobel/procyon/downloads/procyon-decompiler-0.5.36.jar"
  sha256 "74f9f1537113207521a075fafe64bd8265c47a9c73574bbf9fa8854bbf7126bc"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "procyon-decompiler-#{version}.jar"
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
