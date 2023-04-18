class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.1-all.zip"
  sha256 "2cbafcd2c47a101cb2165f636b4677fac0b954949c9429c1c988da399defe6a9"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4fd5709290e61b807c872dff001f33c397109eb5931b6398b5b22f7200fa708"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4fd5709290e61b807c872dff001f33c397109eb5931b6398b5b22f7200fa708"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4fd5709290e61b807c872dff001f33c397109eb5931b6398b5b22f7200fa708"
    sha256 cellar: :any_skip_relocation, ventura:        "47b4f6b12ef507b767a73bb7494542c337fe56f44b61c79b3715022ff0ef9328"
    sha256 cellar: :any_skip_relocation, monterey:       "47b4f6b12ef507b767a73bb7494542c337fe56f44b61c79b3715022ff0ef9328"
    sha256 cellar: :any_skip_relocation, big_sur:        "47b4f6b12ef507b767a73bb7494542c337fe56f44b61c79b3715022ff0ef9328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4fd5709290e61b807c872dff001f33c397109eb5931b6398b5b22f7200fa708"
  end

  # TODO: Switch to `openjdk` on 8.2 release. 8.0 and 8.1 series cannot be run
  # on Java 20: https://github.com/gradle/gradle/issues/23488.
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
