class MavenAT35 < Formula
  desc "Java-based project management"
  homepage "https://maven.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz"
  sha256 "ce50b1c91364cb77efe3776f756a6d92b76d9038b0a0782f7d53acf1e997a14d"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4f685fb12ff8d606e753a10f33ada6e3549adfba01632bb709ec969c74ef5a16"
    sha256 cellar: :any,                 arm64_big_sur:  "395084c1ae2cf3ccfa343ed12c100155bb289658c0f82daa6dd1fd3b215c458d"
    sha256 cellar: :any,                 monterey:       "1056be877616d89127b7f6b702d11d5cf0ea655480d32d57931353b19bddaf25"
    sha256 cellar: :any,                 big_sur:        "395c556575fb1c0d7b89559350c449ded3809b4f711efed178a559cd4d4cc535"
    sha256 cellar: :any,                 catalina:       "395c556575fb1c0d7b89559350c449ded3809b4f711efed178a559cd4d4cc535"
    sha256 cellar: :any,                 mojave:         "395c556575fb1c0d7b89559350c449ded3809b4f711efed178a559cd4d4cc535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f291bcfaa6ed6d4a3c2a0c16dbe8342a55d528cd0c4c66c468f93b6ec7b3883"
  end

  keg_only :versioned_formula

  deprecate! date: "2018-10-24", because: :unmaintained

  depends_on "openjdk"

  def install
    # Remove windows files
    rm_f Dir["bin/*.cmd"]

    # Fix the permissions on the global settings file.
    chmod 0644, "conf/settings.xml"

    libexec.install Dir["*"]

    # Leave conf file in libexec. The mvn symlink will be resolved and the conf
    # file will be found relative to it
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      next if basename.to_s == "m2.conf"

      (bin/basename).write_env_script file, Language::Java.overridable_java_home_env
    end
  end

  test do
    (testpath/"pom.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <project xmlns="https://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="https://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>org.homebrew</groupId>
        <artifactId>maven-test</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <properties>
          <maven.compiler.source>1.8</maven.compiler.source>
          <maven.compiler.target>1.8</maven.compiler.target>
          <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        </properties>
      </project>
    EOS
    (testpath/"src/main/java/org/homebrew/MavenTest.java").write <<~EOS
      package org.homebrew;
      public class MavenTest {
        public static void main(String[] args) {
          System.out.println("Testing Maven with Homebrew!");
        }
      }
    EOS
    system "#{bin}/mvn", "compile", "-Duser.home=#{testpath}"
  end
end
