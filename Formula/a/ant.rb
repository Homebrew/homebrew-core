class Ant < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/binaries/apache-ant-1.10.15-bin.tar.xz"
  mirror "https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.15-bin.tar.xz"
  sha256 "4d5bb20cee34afbad17782de61f4f422c5a03e4d2dffc503bcbd0651c3d3c396"
  license "Apache-2.0"
  revision 1
  head "https://git-wip-us.apache.org/repos/asf/ant.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e222d1b959c3a0b7b5bb343eba4a04d9a6730056f41954c05837828ff128f97"
  end

  depends_on "openjdk"

  resource "ivy" do
    url "https://www.apache.org/dyn/closer.lua?path=ant/ivy/2.5.3/apache-ivy-2.5.3-bin.tar.gz"
    mirror "https://archive.apache.org/dist/ant/ivy/2.5.3/apache-ivy-2.5.3-bin.tar.gz"
    sha256 "3d41e45021b84089e37329ede433e3ca20943cb1be0235390b6ddf4a919a85af"
  end

  resource "bcel" do
    url "https://www.apache.org/dyn/closer.lua?path=commons/bcel/binaries/bcel-6.10.0-bin.tar.gz"
    mirror "https://archive.apache.org/dist/commons/bcel/binaries/bcel-6.10.0-bin.tar.gz"
    sha256 "451557c4fb706d3f405fdd93eb4b8326915617a0e2a2d706d4abcaae515f1165"
  end

  def install
    rm Dir["bin/*.{bat,cmd,dll,exe}"]

    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    rm bin/"ant"
    (bin/"ant").write <<~SHELL
      #!/bin/bash
      JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}" exec "#{libexec}/bin/ant" -lib #{HOMEBREW_PREFIX}/share/ant "$@"
    SHELL

    resource("ivy").stage do
      (libexec/"lib").install Dir["ivy-*.jar"]
    end

    resource("bcel").stage do
      (libexec/"lib").install "bcel-#{resource("bcel").version}.jar"

      # Ensure bcel jar is readable by world, see https://github.com/Homebrew/homebrew-core/issues/203905
      # Fixed upstream in https://github.com/apache/commons-bcel/commit/3afa84f8cc19e56ea550ae743ce0693f4c7d8ec5,
      # remove on next update of bcel resource.
      chmod 0644, libexec/"lib/bcel-#{resource("bcel").version}.jar"
    end
  end

  test do
    (testpath/"build.xml").write <<~XML
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
    XML

    (testpath/"src/main/java/org/homebrew/AntTest.java").write <<~JAVA
      package org.homebrew;
      public class AntTest {
        public static void main(String[] args) {
          System.out.println("Testing Ant with Homebrew!");
        }
      }
    JAVA

    system bin/"ant", "compile"
  end
end
