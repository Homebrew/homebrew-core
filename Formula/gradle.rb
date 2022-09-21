class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  # TODO: switch dependency to `openjdk` on 7.6.
  # Ref: https://github.com/gradle/gradle/issues/20372
  url "https://services.gradle.org/distributions/gradle-7.5.1-all.zip"
  sha256 "db9c8211ed63f61f60292c69e80d89196f9eb36665e369e7f00ac4cc841c2219"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "022acd562e864e9ffd39dabc3c5c45df19b7ebe9aa0dee25b895ef410a01a3b9"
  end

  depends_on "openjdk@17"

  def install
    rm_f Dir["bin/*.bat"]
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
