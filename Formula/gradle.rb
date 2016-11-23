class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-3.2.1-bin.zip"
  sha256 "9843a3654d3e57dce54db06d05f18b664b95c22bf90c6becccb61fc63ce60689"

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
