class Ant < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/binaries/apache-ant-1.10.8-bin.tar.xz"
  mirror "https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.8-bin.tar.xz"
  sha256 "8be685aacf2bfe8515a1249fbebb0ccd861dfe05ee2c027c89fd7912c1ce2c2a"
  license "Apache-2.0"
  revision 1
  head "https://git-wip-us.apache.org/repos/asf/ant.git"

  bottle :unneeded

  depends_on "openjdk"

  resource "ivy" do
    url "https://www.apache.org/dyn/closer.lua?path=ant/ivy/2.4.0/apache-ivy-2.4.0-bin.tar.gz"
    mirror "https://archive.apache.org/dist/ant/ivy/2.4.0/apache-ivy-2.4.0-bin.tar.gz"
    sha256 "7a3d13a80b69d71608191463dfc2a74fff8ef638ce0208e70d54d28ba9785ee9"
  end

  resource "bcel" do
    url "https://www.apache.org/dyn/closer.lua?path=commons/bcel/binaries/bcel-6.4.1-bin.tar.gz"
    mirror "https://archive.apache.org/dist/commons/bcel/binaries/bcel-6.4.1-bin.tar.gz"
    sha256 "1621dfa6418c6c2df83ea4da5eda9eb84955a3332c8e2580dd96e2db95fd8085"
  end

  def install
    rm Dir["bin/*.{bat,cmd,dll,exe}"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    rm bin/"ant"
    (bin/"ant").write <<~EOS
      #!/bin/bash
      JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}" exec "#{libexec}/bin/ant" -lib #{HOMEBREW_PREFIX}/share/ant "$@"
    EOS

    resource("ivy").stage do
      (libexec/"lib").install Dir["ivy-*.jar"]
    end

    resource("bcel").stage do
      (libexec/"lib").install "bcel-#{resource("bcel").version}.jar"
    end
  end

  test do
    (testpath/"build.xml").write <<~EOS
      <project name="HomebrewTest" basedir=".">
        <property name="src" location="src"/>
        <property name="build" location="build"/>
        <target name="init">
          <mkdir dir="${build}"/>
        </target>
        <target name="compile" depends="init">
          <javac srcdir="${src}" destdir="${build}"/>
        </target>
      </project>
    EOS
    (testpath/"src/main/java/org/homebrew/AntTest.java").write <<~EOS
      package org.homebrew;
      public class AntTest {
        public static void main(String[] args) {
          System.out.println("Testing Ant with Homebrew!");
        }
      }
    EOS
    system "#{bin}/ant", "compile"
  end
end
