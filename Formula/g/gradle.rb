class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  # TODO: Switch to `openjdk` 25 when 9.1.0 is released.
  url "https://services.gradle.org/distributions/gradle-9.1.0-all.zip"
  sha256 "b84e04fa845fecba48551f425957641074fcc00a88a84d2aae5808743b35fc85"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e13126cd6030f1b0939f0ffd9f2b22b1cc2640631d96ff6076093bcd6f0fa839"
  end

  # https://github.com/gradle/gradle/blob/master/platforms/documentation/docs/src/docs/userguide/releases/compatibility.adoc
  depends_on "openjdk@21"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env("21")
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
