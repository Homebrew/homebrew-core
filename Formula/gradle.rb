class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-2.13-bin.zip"
  sha256 "0f665ec6a5a67865faf7ba0d825afb19c26705ea0597cec80dd191b0f2cbb664"

  devel do
    url "https://downloads.gradle.org/distributions/gradle-2.14-rc-3-bin.zip"
    sha256 "6b076728aef0adb281bcc31db7b4f83a061caaa36d61f00dc43e606a3de85578"
    version "2.14-rc-3"
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
