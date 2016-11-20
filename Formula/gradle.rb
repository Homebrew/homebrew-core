class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-3.2-bin.zip"
  sha256 "5321b36837226dc0377047a328f12010f42c7bf88ee4a3b1cee0c11040082935"

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
