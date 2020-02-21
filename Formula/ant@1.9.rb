class AntAT19 < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/binaries/apache-ant-1.9.14-bin.tar.bz2"
  mirror "https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.14-bin.tar.bz2"
  sha256 "efad74bd98d9eb72b080a3e08f5b17118e05372d22e3aa3bc0bd1686aa71361c"

  bottle :unneeded

  keg_only :versioned_formula

  def install
    rm Dir["bin/*.{bat,cmd,dll,exe}"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    rm bin/"ant"
    (bin/"ant").write <<~EOS
      #!/bin/sh
      #{libexec}/bin/ant -lib #{HOMEBREW_PREFIX}/share/ant "$@"
    EOS
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
