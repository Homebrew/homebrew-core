class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-7.4.1-all.zip"
  sha256 "a9a7b7baba105f6557c9dcf9c3c6e8f7e57e6b49889c5f1d133f015d0727e4be"
  license "Apache-2.0"

  livecheck do
    url "https://services.gradle.org/distributions/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:[tz])/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4fe73aa465682f972573cdc1788b1895597bd9f01362907c382507e360865519"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env
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
