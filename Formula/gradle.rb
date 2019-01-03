class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-5.1-all.zip"
  sha256 "7b8a8b9cce0406733d2d3fab3874386c530657c73c3f4e9a3837d081e26060d8"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib media samples src]
    (bin/"gradle").write_env_script libexec/"bin/gradle", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")
  end
end
