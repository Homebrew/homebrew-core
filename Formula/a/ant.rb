class Ant < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/binaries/apache-ant-1.10.15-bin.tar.xz"
  mirror "https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.15-bin.tar.xz"
  sha256 "4d5bb20cee34afbad17782de61f4f422c5a03e4d2dffc503bcbd0651c3d3c396"
  license "Apache-2.0"
  head "https://git-wip-us.apache.org/repos/asf/ant.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c666080c76ed9c83e4d6a62bf1f00514a01b6b2bc6db604e8ed91b5121a9f8fc"
  end

  depends_on "openjdk"

  resource "ivy" do
    url "https://www.apache.org/dyn/closer.lua?path=ant/ivy/2.5.2/apache-ivy-2.5.2-bin.tar.gz"
    mirror "https://archive.apache.org/dist/ant/ivy/2.5.2/apache-ivy-2.5.2-bin.tar.gz"
    sha256 "c673ad3a8b09935c1a0cee8551fb6fd9eb7b0cf3b5e5104047af478ef60517a2"
  end

  resource "bcel" do
    url "https://www.apache.org/dyn/closer.lua?path=commons/bcel/binaries/bcel-6.9.0-bin.tar.gz"
    mirror "https://archive.apache.org/dist/commons/bcel/binaries/bcel-6.9.0-bin.tar.gz"
    sha256 "704ea422628e5c105dfb4f59878fa6a02cb7113932fb5c5997da30dc1b9740c6"
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

    system bin/"ant", "compile"
  end
end
