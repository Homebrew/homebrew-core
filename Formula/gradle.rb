class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-5.4.1-all.zip"
  sha256 "14cd15fc8cc8705bd69dcfa3c8fefb27eb7027f5de4b47a8b279218f76895a91"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib media samples src]
    (bin/"gradle").write_env_script libexec/"bin/gradle", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")
  end
end
