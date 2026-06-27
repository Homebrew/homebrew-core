class Mvnvm < Formula
  desc "Maven version manager"
  # upstream homepage bug report, https://bitbucket.org/mjensen/mvnvm/issues/41/https-mvnvmorg-is-not-reachable
  homepage "https://bitbucket.org/mjensen/mvnvm/"
  url "https://bitbucket.org/mjensen/mvnvm/get/mvnvm-1.0.29.tar.gz"
  sha256 "f3004baa68051fe64b2ab212fea57cb05dcc598e334f2529b9ca936a3b275b0e"
  license "Apache-2.0"
  head "https://bitbucket.org/mjensen/mvnvm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "03af6e6b002c6e176d523f5d182400b70066fa9f2350155a2cd51abd249b122a"
  end

  depends_on "openjdk"

  conflicts_with "maven", because: "both install `mvn` executables"

  def install
    bin.install "mvn"
    bin.install "mvnDebug"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"settings.xml").write <<~XML
      <settings><localRepository>#{testpath}/repository</localRepository></settings>
    XML
    (testpath/"mvnvm.properties").write <<~EOS
      mvn_version=3.5.2
    EOS
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
    system bin/"mvn", "-gs", testpath/"settings.xml", "compile"
  end
end
