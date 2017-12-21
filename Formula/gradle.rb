class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-4.4.1-all.zip"
  sha256 "dd9b24950dc4fca7d1ca5f1ccd57ca8c5b9eb407e3e6e0f48174fde4bb19ed06"

  bottle :unneeded

  option "with-all", "Installs Javadoc, examples, and source in addition to the binaries"

  depends_on :java => "1.7+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    libexec.install %w[docs media samples src] if build.with? "all"
    (bin/"gradle").write_env_script libexec/"bin/gradle", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")
  end
end
