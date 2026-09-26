class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-9.8.0-all.zip"
  sha256 "46ac66d47f30f3dacfdf306e0b714a91a34fb94a22ba0a744b280933f47bc0cf"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/releases/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69e2b16cbfaf650571d90e7967fca5b492615e5c94e89e6c3587fd90341812e9"
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
