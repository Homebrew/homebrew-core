class AntAT19 < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/binaries/apache-ant-1.9.16-bin.tar.bz2"
  mirror "https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.16-bin.tar.bz2"
  sha256 "57ceb0b249708cb28d081a72045657ab067fc4bc4a0d1e4af252496be44c2e66"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a881e6229607ce27db2cf3686cc2f28deeb04d2e3a0e6f0967438dd123516eab"
  end

  keg_only :versioned_formula

  # End-of-life on 2024-06-19: https://lists.apache.org/thread/f6jw4v3gjwhqt5fz25og0my2o6xwvvm1
  deprecate! date: "2024-07-24", because: :unsupported
  disable! date: "2025-07-26", because: :unsupported

  depends_on "openjdk"

  def install
    rm Dir["bin/*.{bat,cmd,dll,exe}"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    rm bin/"ant"
    (bin/"ant").write <<~SHELL
      #!/bin/sh
      JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}" exec "#{libexec}/bin/ant" -lib #{HOMEBREW_PREFIX}/share/ant "$@"
    SHELL
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
