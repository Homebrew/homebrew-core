class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.10.2-all.zip"
  sha256 "2ab88d6de2c23e6adae7363ae6e29cbdd2a709e992929b48b6530fd0c7133bd6"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dafd94cea91ba78ace18ab7f7201a6b2b9f4c2974b6d26125c5275bf226f7556"
  end

  # https://github.com/gradle/gradle/blob/master/platforms/documentation/docs/src/docs/userguide/releases/compatibility.adoc
  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env
    (bin/"gradle").write_env_script libexec/"bin/gradle", env

    # Ensure we have uniform bottles.
    inreplace libexec/"src/jvm-services/org/gradle/jvm/toolchain/internal/LinuxInstallationSupplier.java",
              "/usr/local", HOMEBREW_PREFIX
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
