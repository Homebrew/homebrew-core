class Ant < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=ant/binaries/apache-ant-1.10.7-bin.tar.xz"
  mirror "https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.7-bin.tar.xz"
  sha256 "925fa954d82b6edf5cfd51fc66659d6e02cf1a6a082c3c41fe83f604c2d17c02"
  revision 1
  head "https://git-wip-us.apache.org/repos/asf/ant.git"

  bottle :unneeded

  depends_on "openjdk"

  resource "ivy" do
    url "https://www.apache.org/dyn/closer.cgi?path=ant/ivy/2.4.0/apache-ivy-2.4.0-bin.tar.gz"
    sha256 "7a3d13a80b69d71608191463dfc2a74fff8ef638ce0208e70d54d28ba9785ee9"
  end

  resource "bcel" do
    url "https://archive.apache.org/dist/commons/bcel/binaries/bcel-6.4.0-bin.tar.gz"
    sha256 "2e7d3c24fabc5a24c482ddc77c031d9f5978c5aa918bae68ad7adcf3e9167d04"
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
