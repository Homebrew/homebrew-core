class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-3.1-bin.zip"
  sha256 "c7de3442432253525902f7e8d7eac8b5fd6ce1623f96d76916af6d0e383010fc"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec/"bin/gradle"
  end

  test do
    ENV.java_cache
    assert_match version.to_s, shell_output("#{bin}/gradle --version")
  end
end
