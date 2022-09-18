class JacocoCli < Formula
  desc "JaCoCo Java Code Coverage Library Command-line"
  homepage "https://github.com/jacoco/jacoco"
  url "https://search.maven.org/remotecontent?filepath=org/jacoco/org.jacoco.cli/0.8.8/org.jacoco.cli-0.8.8-nodeps.jar"
  sha256 "c449591174982bbc003d1290003fcbc7b939215436922d2f0f25239d110d531a"
  license "EPL-2.0"

  depends_on "gradle" => :test
  depends_on "openjdk"

  def install
    libexec.install "org.jacoco.cli-#{version}-nodeps.jar"
    bin.write_jar_script libexec/"org.jacoco.cli-#{version}-nodeps.jar", "jacoco-cli"
  end

  test do
    # Setup build script, including JUnit and JaCoCo Gradle Plugin
    (testpath/"build.gradle").write <<~EOS
      plugins {
          id 'java'
          id 'jacoco'
      }

      group 'org.example'
      version '1.0-SNAPSHOT'

      repositories {
          mavenCentral()
      }

      dependencies {
          testImplementation 'junit:junit:4.13.1'
      }
      java {
          sourceCompatibility = JavaVersion.VERSION_18
          sourceCompatibility = JavaVersion.VERSION_18
      }
      test {
          finalizedBy jacocoTestReport
      }
      jacocoTestReport {
          dependsOn test
      }
      jacoco {
          toolVersion = "#{version}"
      }
    EOS
    # Setup one Java class and one Java test class
    (testpath/"src/main/java/org/example/SimpleAddition.java").write <<~EOS
      package org.example;
      public class SimpleAddition {
          public int add(int a, int b) {
              return a + b;
          }
      }
    EOS
    (testpath/"src/test/java/org/example/SimpleAdditionTest.java").write <<~EOS
      package org.example;
      import org.junit.Assert;
      import org.junit.Test;
      public class SimpleAdditionTest {
          @Test
          public void testAdd() {
              Assert.assertEquals(3, new SimpleAddition().add(1, 2));
          }
      }
    EOS

    # Run unit test with coverage using Gradle
    system "gradle", "test"

    # Use jacoco-cli to generate xml coverage report
    (testpath/"output").mkpath
    system bin/"jacoco-cli", "report", testpath/"build/jacoco/test.exec",
                             "--classfiles", testpath/"build/classes/",
                             "--sourcefiles", testpath/"src/main/java/",
                             "--xml", testpath/"output/unitTestCoverage.xml"

    # Compare key node in generated xml coverage report with expected value
    assert_match "covered=\"2\"",
      shell_output("xmllint --xpath \
        '/report/package/sourcefile[@name=\"SimpleAddition.java\"]/counter[@type=\"LINE\"]/@covered' \
         #{testpath}/output/unitTestCoverage.xml")
  end
end
