class Beanshell < Formula
  desc "Java Beanshell - Lightweight Scripting for Java"
  homepage "http://www.beanshell.org/"
  url "http://www.beanshell.org/bsh-2.0b4.jar"
  sha256 "91395c07885839a8c6986d5b7c577cd9bacf01bf129c89141f35e8ea858427b6"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "bsh-#{version}.jar"

    (bin/"bsh").write <<~EOS
      #!/bin/sh
      java -cp "#{libexec}/bsh-#{version}.jar" bsh.Interpreter "$@";
    EOS
  end

  test do
    system "#{bin}/bsh", "-h"
  end
end
