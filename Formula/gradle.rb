class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-3.4-all.zip"
  sha256 "37c2fdce55411e4c89b896c292cae1f8f437862c8433c8a74cfc3805d7670c0a"

  bottle :unneeded

  option "with-all", "Installs Javadoc, examples, and source in addition to the binaries"

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
