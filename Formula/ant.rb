class Ant < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=ant/binaries/apache-ant-1.10.1-bin.tar.xz"
  sha256 "51dd6b4ec740013dc5ad71812ce5d727a9956aa3a56de7164c76cbd70d015d79"
  head "https://git-wip-us.apache.org/repos/asf/ant.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f2d0b309804add26321af31b17162daf3e923b8799100e987272b18ee2c53c9" => :high_sierra
    sha256 "50070b39168c9da1a5375a19fb1073f2a15b3a640e5433d10625eb9e170b4178" => :sierra
    sha256 "50070b39168c9da1a5375a19fb1073f2a15b3a640e5433d10625eb9e170b4178" => :el_capitan
    sha256 "50070b39168c9da1a5375a19fb1073f2a15b3a640e5433d10625eb9e170b4178" => :yosemite
  end

  keg_only :provided_by_macos if MacOS.version < :mavericks

  option "with-ivy", "Install ivy dependency manager"
  option "with-bcel", "Install Byte Code Engineering Library"

  depends_on :java => "1.8+"

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
    (bin/"ant").write <<~EOS
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
