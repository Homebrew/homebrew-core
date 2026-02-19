class Maven < Formula
  desc "Java-based project management"
  homepage "https://maven.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=maven/maven-3/3.9.12/binaries/apache-maven-3.9.12-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.9.12/binaries/apache-maven-3.9.12-bin.tar.gz"
  sha256 "fa2c9948729296c23afd18fd01a90f62cdda09a46191b54a8bc3764c2eee812e"
  license "Apache-2.0"

  livecheck do
    url "https://maven.apache.org/download.cgi"
    regex(/href=.*?apache-maven[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aee06a657afd6f9c20b4183c0c8e90325dfc29c75f300eaf22556852e58d4676"
  end

  depends_on "openjdk"

  conflicts_with "mvnvm", because: "both install `mvn` executables"

  def install
    # Remove windows files
    rm(Dir["bin/*.cmd"])

    # Fix the permissions on the global settings file.
    chmod 0644, "conf/settings.xml"

    libexec.install Dir["*"]

    # Build an `:all` bottle by changing the path for `mavenrc`
    file = libexec/"bin/mvn"
    inreplace file, "/usr/local/etc/mavenrc", "#{HOMEBREW_PREFIX}/etc/mavenrc"

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
    (testpath/"pom.xml").write <<~XML
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
    XML

    (testpath/"src/main/java/org/homebrew/MavenTest.java").write <<~JAVA
      package org.homebrew;
      public class MavenTest {
        public static void main(String[] args) {
          System.out.println("Testing Maven with Homebrew!");
        }
      }
    JAVA

    system bin/"mvn", "compile", "-Duser.home=#{testpath}"
  end
end
