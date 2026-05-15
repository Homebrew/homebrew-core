class GradleAT7 < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-7.6.6-all.zip"
  sha256 "6ed4d467349e2d3f555a578829c4aeadd67d73e2ec5d213c2a62f8f2829d9fa9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d65eb2a55c0be7b144b661bea1d9f3df08d67eb0aa7a033c3088a58272b7b2db"
  end

  keg_only :versioned_formula

  # EOL with Gradle 9 release on 2025-07-31.
  # https://docs.gradle.org/current/userguide/feature_lifecycle.html#eol_support
  deprecate! date: "2025-07-31", because: :unmaintained
  disable! date: "2026-07-31", because: :unmaintained

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
