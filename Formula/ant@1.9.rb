class AntAT19 < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=ant/binaries/apache-ant-1.9.11-bin.tar.bz2"
  sha256 "15f305b371d63952d8b5e10c3a63a91c4616696690bfb0094e7624bc94077c3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "eafef358409b3f160ab83140dc9f31fbc2ca0a3a250c0e39ddd30aa793c913cd" => :high_sierra
    sha256 "eafef358409b3f160ab83140dc9f31fbc2ca0a3a250c0e39ddd30aa793c913cd" => :sierra
    sha256 "eafef358409b3f160ab83140dc9f31fbc2ca0a3a250c0e39ddd30aa793c913cd" => :el_capitan
  end

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
