require "net/http"
require "json"

class Maven < Formula
  desc "Java-based project management"
  homepage "https://maven.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz"
  sha256 "26ad91d751b3a9a53087aefa743f4e16a17741d3915b219cf74112bf87a438c5"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
  end

  head do
    def download_json(url)
      response = Net::HTTP.get(URI(url))
      JSON.parse(response)
    end

    def find_latest
      jenkins_base_url = "https://ci-builds.apache.org/job/Maven/job/maven-box/job/maven/job/master"

      download_json("#{jenkins_base_url}/api/json")["builds"].each do |build|
        build_details = download_json("#{jenkins_base_url}/#{build["number"]}/api/json")

        next unless build_details["result"] == "SUCCESS"

        build_details["artifacts"].each do |artifact|
          next unless artifact["fileName"].match?(/^apache-maven-[^wrapper].*-bin\.tar\.gz$/)

          return "#{jenkins_base_url}/#{build["number"]}/artifact/#{artifact["relativePath"]}"
        end
        raise "Expected to find an artifact named apache-maven * tar.gz, but it wasn't found"
      end
    end

    url find_latest
  end

  bottle :unneeded

  depends_on "openjdk"

  conflicts_with "mvnvm", because: "also installs a 'mvn' executable"

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
