class GradleAT6 < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-6.9.4-all.zip"
  sha256 "84b50e7b380e9dc9bbc81e30a8eb45371527010cf670199596c86875f774b8b0"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "26f425b0db255ccba20afda007fc2157720580605fab130693c8e536af362556"
  end

  keg_only :versioned_formula

  # EOL with Gradle 8 release on 2023-02-10.
  # https://docs.gradle.org/current/userguide/feature_lifecycle.html#eol_support
  disable! date: "2024-12-14", because: :unmaintained

  # gradle@6 does not support Java 16
  depends_on "openjdk@11"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin docs lib src]
    (bin/"gradle").write_env_script libexec/"bin/gradle", Language::Java.overridable_java_home_env("11")
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
