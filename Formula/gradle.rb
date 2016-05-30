class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-2.13-bin.zip"
  sha256 "0f665ec6a5a67865faf7ba0d825afb19c26705ea0597cec80dd191b0f2cbb664"

  devel do
    url "https://downloads.gradle.org/distributions/gradle-2.14-rc-2-bin.zip"
    sha256 "eb824186223dec65fc3f9bb2755934b38c1cd005a0e6f0d80e282a2390214735"
    version "2.14-rc-2"
  end

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install %w[bin lib]
    (bin/"gradle").write_env_script libexec/"bin/gradle",
      Language::Java.java_home_env.merge(:GRADLE_HOME => libexec)
  end

  test do
    ENV.java_cache
    assert_match(/Gradle #{version}/, shell_output("#{bin}/gradle --version"))
  end
end
