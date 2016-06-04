class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-2.13-bin.zip"
  sha256 "0f665ec6a5a67865faf7ba0d825afb19c26705ea0597cec80dd191b0f2cbb664"

  devel do
    url "https://downloads.gradle.org/distributions/gradle-2.14-rc-4-bin.zip"
    sha256 "471424c0998851572c8b0ac71807215fc717de1373dcb5b64889e0aa5d147d26"
    version "2.14-rc-4"
  end

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+"bin/gradle"
  end

  test do
    ENV.java_cache
    assert_match(/Gradle #{version}/, shell_output("#{bin}/gradle --version"))
  end
end
