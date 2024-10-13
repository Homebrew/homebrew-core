class GradleAT7 < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-7.6.4-all.zip"
  sha256 "fe696c020f241a5f69c30f763c5a7f38eec54b490db19cd2b0962dda420d7d12"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/releases/"
    regex(/href=.*?gradle[._-]v?(7(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a21f307c8efb2668f37f8fd1c61444ca414e9f903330a19603771f1de5d5615a"
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
    (testpath/"build.gradle").write <<~EOS
      println "gradle works!"
    EOS
    gradle_output = shell_output("#{bin}/gradle build --no-daemon")
    assert_includes gradle_output, "gradle works!"
  end
end
