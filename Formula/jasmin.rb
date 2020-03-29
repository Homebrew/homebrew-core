class Jasmin < Formula
  desc "Assembler for the Java Virtual Machine"
  homepage "https://jasmin.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jasmin/jasmin/jasmin-2.4/jasmin-2.4.zip"
  sha256 "eaa10c68cec68206fd102e9ec7113739eccd790108a1b95a6e8c3e93f20e449d"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["*.bat"]

    libexec.install Dir["*.jar"]
    prefix.install %w[Readme.txt license-ant.txt license-jasmin.txt]
    (bin/"jasmin").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/jasmin.jar" "$@"
    EOS
  end

  test do
    (testpath/"test.j").write <<~EOS
      .class public HomebrewTest
      .super java/lang/Object
       .method public <init>()V
         aload_0
         invokespecial java/lang/Object/<init>()V
         return
      .end method
       .method public static main([Ljava/lang/String;)V
         .limit stack 2
         getstatic java/lang/System/out Ljava/io/PrintStream;
         ldc "Hello Homebrew"
         invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
         return
      .end method
    EOS
    system "#{bin}/jasmin", "#{testpath}/test.j"
    assert_equal "Hello Homebrew\n", shell_output("java HomebrewTest")
  end
end
