class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-9.9.3-all.zip"
  sha256 "5b28389b6ce6c651f4b04d7d190462e436afca9282d16c2c646ca416fd9e2747"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url "https://gradle.org/releases/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    manifest_sha256 "c35d1c548b636d8b0446254cf8cdd0f7a576d075d680fe0e60ddeac15f54cdc7"
    sha256 cellar: :any_skip_relocation, all: "7e01dfd065875a9f59166beea82d0ec646355fda95832502263e588c36dae59e"
  end

  depends_on "gradle-completion"
  depends_on "openjdk"

  allow_network_access! :test

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin lib src] # excluding 300MB+ of docs
    env = Language::Java.overridable_java_home_env
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
