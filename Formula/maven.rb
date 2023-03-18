class Maven < Formula
  desc "Java-based project management"
  homepage "https://maven.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz"
  sha256 "0869a4f71238e3eeec21051d062cfd915d34abe905c9bfebf94cd34578db0be7"
  license "Apache-2.0"

  livecheck do
    url "https://maven.apache.org/download.cgi"
    regex(/href=.*?apache-maven[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19f6ad8a78cf93dcb00a8e8f5efe44a2fff7c19ff37a34fe9395b8a7b1833ba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c98ed4b6e89ebbb0f7c9c61919e29682bc01b85e4f86a3192d54ca65fe3b2744"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52232c26dde8c6fc5a2a4ba8a91079916525f670c997c365f777d9db98b3bedd"
    sha256 cellar: :any_skip_relocation, ventura:        "4735ca305866713ee9d8c86ee3ad1e95d9149887b85888f0244aeb5986b1c692"
    sha256 cellar: :any_skip_relocation, monterey:       "a1a2e0640b686564174f17ecf481135c5b29ee71f2637853a9af1d83becffc8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2efa650c771e9d1e0e3b1004449408e9acd862ddecfc712039bb0d22a57b0bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b43474278ad5bd5d050973ce33506a64b4beae218c73fd56b8b8a5386358eda9"
  end

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
