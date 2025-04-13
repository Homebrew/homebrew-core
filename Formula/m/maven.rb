class Maven < Formula
  desc "Java-based project management"
  homepage "https://maven.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz"
  sha256 "7a9cdf674fc1703d6382f5f330b3d110ea1b512b51f1652846d9e4e8a588d766"
  license "Apache-2.0"

  livecheck do
    url "https://maven.apache.org/download.cgi"
    regex(/href=.*?apache-maven[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "106bdaaec0342b1656442dd5d1521b3edf69df22576726110bf1d56af0d4bfef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "106bdaaec0342b1656442dd5d1521b3edf69df22576726110bf1d56af0d4bfef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "106bdaaec0342b1656442dd5d1521b3edf69df22576726110bf1d56af0d4bfef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "106bdaaec0342b1656442dd5d1521b3edf69df22576726110bf1d56af0d4bfef"
    sha256 cellar: :any_skip_relocation, sonoma:         "019b91415dce288368bd462ebbfa009a262f7d9a4eb05f1bf64a4d09c4f65d91"
    sha256 cellar: :any_skip_relocation, ventura:        "019b91415dce288368bd462ebbfa009a262f7d9a4eb05f1bf64a4d09c4f65d91"
    sha256 cellar: :any_skip_relocation, monterey:       "019b91415dce288368bd462ebbfa009a262f7d9a4eb05f1bf64a4d09c4f65d91"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bef4d063e3e32355e8b2d139fd09395bbbfcadb87af73403984c6c9ce146fcf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "106bdaaec0342b1656442dd5d1521b3edf69df22576726110bf1d56af0d4bfef"
  end

  depends_on "openjdk"

  conflicts_with "mvnvm", because: "also installs a 'mvn' executable"

  def install
    # Remove windows files
    rm(Dir["bin/*.cmd"])

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
