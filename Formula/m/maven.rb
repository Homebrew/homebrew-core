class Maven < Formula
  desc "Java-based project management"
  homepage "https://maven.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=maven/maven-3/3.9.7/binaries/apache-maven-3.9.7-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.9.7/binaries/apache-maven-3.9.7-bin.tar.gz"
  sha256 "c8fb9f620e5814588c2241142bbd9827a08e3cb415f7aa437f2ed44a3eeab62c"
  license "Apache-2.0"

  livecheck do
    url "https://maven.apache.org/download.cgi"
    regex(/href=.*?apache-maven[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e31233aec51e9b37653798984741209a44e769c8914aba43b9d62955fa6e588"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ecc0f30c8411183c4121022589b65ee6ba9944e483fa8205c5a8185faff5ea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef7c2e9b52a57117fa0b52d44984598da24fc8e94eacff8354d50712c7d4915c"
    sha256 cellar: :any_skip_relocation, sonoma:         "eac400de7adb33167cccc137f3350d859092ca4b43a1048d1f92a90e89abc63c"
    sha256 cellar: :any_skip_relocation, ventura:        "dd488fd2cc5fc663b4187b1273e0b8b0a9fe510fc4f0fc8b0adaaeaee89cb932"
    sha256 cellar: :any_skip_relocation, monterey:       "240f0b40a436c827d062016c3ffbf677f3fa77caca41b2ced9fcdedaf18cf39e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20b539139ee4c37f58643fad4733075874085ee0236b33660754981f08c2db3e"
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
