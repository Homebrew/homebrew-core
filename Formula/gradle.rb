class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-2.13-bin.zip"
  sha256 "0f665ec6a5a67865faf7ba0d825afb19c26705ea0597cec80dd191b0f2cbb664"

  devel do
    url "https://downloads.gradle.org/distributions/gradle-2.14-rc-5-bin.zip"
    sha256 "dcdd1021345cfabd2c06a345700afe537bde5478cfb8c3ac59d6348eeb0647e9"
    version "2.14-rc-5"
  end

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.overridable_java_home_env("1.6+"))
  end

  test do
    ENV.java_cache
    assert_match(/Gradle #{version}/, shell_output("#{bin}/gradle --version"))
  end
end
