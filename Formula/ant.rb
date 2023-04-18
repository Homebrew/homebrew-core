class Ant < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/binaries/apache-ant-1.10.13-bin.tar.xz"
  mirror "https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.13-bin.tar.xz"
  sha256 "de0a860bf339e6975558f426772a6aa2c6ae0856215dd9aaf57aa2476d665664"
  license "Apache-2.0"
  head "https://git-wip-us.apache.org/repos/asf/ant.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "592b81d01d7daff43e4a5a5eb555f14457410ccac8a623982a65ab412709a394"
  end

  depends_on "openjdk"

  resource "ivy" do
    url "https://www.apache.org/dyn/closer.lua?path=ant/ivy/2.5.1/apache-ivy-2.5.1-bin.tar.gz"
    mirror "https://archive.apache.org/dist/ant/ivy/2.5.1/apache-ivy-2.5.1-bin.tar.gz"
    sha256 "ce9d3d5e37f6bc3c95a21efc94ae4ab73ec27b3e8d0d86515b44b562c4bb431e"
  end

  resource "bcel" do
    url "https://www.apache.org/dyn/closer.lua?path=commons/bcel/binaries/bcel-6.7.0-bin.tar.gz"
    mirror "https://archive.apache.org/dist/commons/bcel/binaries/bcel-6.7.0-bin.tar.gz"
    sha256 "d1bee25e9da24f0a9c808dc8137fcfc7fe662d3d3ac95eaee477586e8bb1ea2e"
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
