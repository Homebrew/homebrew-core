class Ant < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/binaries/apache-ant-1.10.12-bin.tar.xz"
  mirror "https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.12-bin.tar.xz"
  sha256 "6115c940367e50755cf806de5816f20a1db1321b1cb734e2c34ab20ef6682b9b"
  license "Apache-2.0"
  head "https://git-wip-us.apache.org/repos/asf/ant.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65361546d11f6cd675bc64aae75cd14dc3e77e7ed466b45e871bd09780df23f1"
  end

  depends_on "openjdk"

  resource "ivy" do
    url "https://www.apache.org/dyn/closer.lua?path=ant/ivy/2.5.0/apache-ivy-2.5.0-bin.tar.gz"
    mirror "https://archive.apache.org/dist/ant/ivy/2.5.0/apache-ivy-2.5.0-bin.tar.gz"
    sha256 "3855a5769b5dbeafa9fb6a00f130467fd0f89da684a0b33a91e3dc5dae2715c7"
  end

  resource "bcel" do
    url "https://www.apache.org/dyn/closer.lua?path=commons/bcel/binaries/bcel-6.5.0-bin.tar.gz"
    mirror "https://archive.apache.org/dist/commons/bcel/binaries/bcel-6.5.0-bin.tar.gz"
    sha256 "023114972b8a2c267f832eab9349b6b475e8c6df559f207e33324877cf17fa30"
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
