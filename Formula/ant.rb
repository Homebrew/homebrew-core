class Ant < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=ant/binaries/apache-ant-1.10.0-bin.tar.bz2"
  sha256 "1c34158fb1e3b56c843afae3ef91a60e779f91f63e69d69150698c049d2893c5"
  head "https://git-wip-us.apache.org/repos/asf/ant.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f4d965e345f128f5ed9871467f37ab46495bac7590c0d51827ed7398a61c42d" => :sierra
    sha256 "66ecee3d85ab96e761df300f6b6128f7e3f806ab2f3674d880107be0b886e73a" => :el_capitan
    sha256 "66ecee3d85ab96e761df300f6b6128f7e3f806ab2f3674d880107be0b886e73a" => :yosemite
  end

  keg_only :provided_by_osx if MacOS.version < :mavericks

  option "with-ivy", "Install ivy dependency manager"
  option "with-bcel", "Install Byte Code Engineering Library"

  resource "ivy" do
    url "https://www.apache.org/dyn/closer.cgi?path=ant/ivy/2.4.0/apache-ivy-2.4.0-bin.tar.gz"
    sha256 "7a3d13a80b69d71608191463dfc2a74fff8ef638ce0208e70d54d28ba9785ee9"
  end

  resource "bcel" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/bcel/bcel/6.0/bcel-6.0.jar"
    sha256 "7eb80fdb30034dda26ba109a1b76af8dae0782c8cd27db32f1775086482d5bd0"
  end

  def install
    rm Dir["bin/*.{bat,cmd,dll,exe}"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    rm bin/"ant"
    (bin/"ant").write <<-EOS.undent
      #!/bin/sh
      #{libexec}/bin/ant -lib #{HOMEBREW_PREFIX}/share/ant "$@"
    EOS
    if build.with? "ivy"
      resource("ivy").stage do
        (libexec/"lib").install Dir["ivy-*.jar"]
      end
    end
    if build.with? "bcel"
      resource("bcel").stage do
        (libexec/"lib").install Dir["bcel-*.jar"]
      end
    end
  end

  test do
    (testpath/"build.xml").write <<-EOS.undent
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
    (testpath/"src/main/java/org/homebrew/AntTest.java").write <<-EOS.undent
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
