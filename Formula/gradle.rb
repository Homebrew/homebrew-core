class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-2.14.1-bin.zip"
  sha256 "cfc61eda71f2d12a572822644ce13d2919407595c2aec3e3566d2aab6f97ef39"

  devel do
    url "https://downloads.gradle.org/distributions/gradle-3.0-milestone-2-bin.zip"
    sha256 "5c3e8e9a38c92ae85e05df609c6c1b6f51e5a08b39a26d61bd8a7044268135e7"
    version "3.0-milestone-2"
  end

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec/"bin/gradle"
  end

  test do
    ENV.java_cache
    assert_match version.to_s, shell_output("#{bin}/gradle --version")
  end
end
