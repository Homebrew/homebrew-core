class AntAT19 < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/binaries/apache-ant-1.9.16-bin.tar.bz2"
  mirror "https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.16-bin.tar.bz2"
  sha256 "57ceb0b249708cb28d081a72045657ab067fc4bc4a0d1e4af252496be44c2e66"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/href=.*?apache-ant[._-]v?(1\.9(?:\.\d+)*)(?:-bin)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "94ee3db86c4f18ca79a37125ad2bfeb56298a46ae197f9ac570c1364b6dac3da"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    rm Dir["bin/*.{bat,cmd,dll,exe}"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    rm bin/"ant"
    (bin/"ant").write <<~EOS
      #!/bin/sh
      JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}" exec "#{libexec}/bin/ant" -lib #{HOMEBREW_PREFIX}/share/ant "$@"
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
