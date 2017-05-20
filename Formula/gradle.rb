class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions-snapshots/gradle-4.0-20170426102539+0000-bin.zip"
  sha256 "4e502f1c152c0df787e7cd8fcb043c3d03a8c65cf1d8ae46c9475ddbc80ceebb"
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
