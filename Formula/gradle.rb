class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-3.2.1-all.zip"
  sha256 "0209696f1723f607c475109cf3ed8b51c8a91bb0cda05af0d4bd980bdefe75cd"

  option "with-all", "Installs Javadoc, examples, and source in addition to the binaries"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install %w[bin lib]
    libexec.install %w[docs media samples src] if build.with? "all"
    bin.install_symlink libexec/"bin/gradle"
  end

  test do
    ENV.java_cache
    assert_match version.to_s, shell_output("#{bin}/gradle --version")
  end
end
