class Mvnvm < Formula
  desc "Maven version manager"
  # upstream homepage bug report, https://bitbucket.org/mjensen/mvnvm/issues/41/https-mvnvmorg-is-not-reachable
  homepage "https://bitbucket.org/mjensen/mvnvm/"
  url "https://bitbucket.org/mjensen/mvnvm/get/mvnvm-1.0.27.tar.gz"
  sha256 "0199150051bb195bc1cafe6a9be5455f5fb21e7c9ac6585f619c613c9f05e425"
  license "Apache-2.0"
  head "https://bitbucket.org/mjensen/mvnvm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce257f2b19fca7291f6ba8c2d0b691be868e3547b5bcf7ebe630cd616b835e5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce257f2b19fca7291f6ba8c2d0b691be868e3547b5bcf7ebe630cd616b835e5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce257f2b19fca7291f6ba8c2d0b691be868e3547b5bcf7ebe630cd616b835e5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce257f2b19fca7291f6ba8c2d0b691be868e3547b5bcf7ebe630cd616b835e5f"
    sha256 cellar: :any_skip_relocation, ventura:        "ce257f2b19fca7291f6ba8c2d0b691be868e3547b5bcf7ebe630cd616b835e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "ce257f2b19fca7291f6ba8c2d0b691be868e3547b5bcf7ebe630cd616b835e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c337aaf385ce221759c33e6564f01057c65d06116d2c0770a6d675e714f42666"
  end

  depends_on "openjdk"

  conflicts_with "maven", because: "also installs a 'mvn' executable"

  def install
    bin.install "mvn"
    bin.install "mvnDebug"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"settings.xml").write <<~EOS
      <settings><localRepository>#{testpath}/repository</localRepository></settings>
    EOS
    (testpath/"mvnvm.properties").write <<~EOS
      mvn_version=3.5.2
    EOS
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
    system "#{bin}/mvn", "-gs", "#{testpath}/settings.xml", "compile"
  end
end
