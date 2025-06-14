class GradleAT7 < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-7.6.5-all.zip"
  sha256 "1141950aa278680458c6115d252231b96dc3ecc014ec123d01351d44ca016e8b"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/releases/"
    regex(/href=.*?gradle[._-]v?(7(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06d7151adcd4d1affc762de7ff751c7a9c7e79f0187b66f27a54684f34aad1f9"
  end

  keg_only :versioned_formula

  # TODO: Check if support for running on Java 20 is backported to Gradle 7.x.
  depends_on "openjdk@17"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env("17")
    (bin/"gradle").write_env_script libexec/"bin/gradle", env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")

    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write <<~GRADLE
      println "gradle works!"
    GRADLE
    gradle_output = shell_output("#{bin}/gradle build --no-daemon")
    assert_includes gradle_output, "gradle works!"
  end
end
