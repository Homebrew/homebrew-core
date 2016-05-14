class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-2.13-bin.zip"
  sha256 "0f665ec6a5a67865faf7ba0d825afb19c26705ea0597cec80dd191b0f2cbb664"

  bottle :unneeded

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+"bin/gradle"
  end

  test do
    ENV.java_cache
    output = shell_output("#{bin}/gradle --version")
    assert_match /Gradle #{version}/, output
  end
end
