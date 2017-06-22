class MavenAT32 < Formula
  desc "Java-based project management"
  homepage "https://maven.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz"
  sha256 "8c190264bdf591ff9f1268dc0ad940a2726f9e958e367716a09b8aaa7e74a755"

  bottle do
    cellar :any_skip_relocation
    sha256 "a29e76e46f1ba51fca6a76e3895ac347824a0c37fca5854d9a1aa2831f0e0510" => :sierra
    sha256 "963e0b933d75dfb2fb4189da9ff20796bbab4dc8f1318ecc7964dc99fab9e9df" => :el_capitan
    sha256 "963e0b933d75dfb2fb4189da9ff20796bbab4dc8f1318ecc7964dc99fab9e9df" => :yosemite
  end

  depends_on :java

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, "conf/settings.xml"

    prefix.install_metafiles
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
    (testpath/"pom.xml").write <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <project xmlns="https://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="https://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>org.homebrew</groupId>
        <artifactId>maven-test</artifactId>
        <version>1.0.0-SNAPSHOT</version>
      </project>
    EOS
    (testpath/"src/main/java/org/homebrew/MavenTest.java").write <<-EOS.undent
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
