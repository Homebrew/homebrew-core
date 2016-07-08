class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-2.14-bin.zip"
  sha256 "993b4f33b652c689e9721917d8e021cab6bbd3eae81b39ab2fd46fdb19a928d5"

  devel do
    url "https://downloads.gradle.org/distributions/gradle-3.0-milestone-1-bin.zip"
    sha256 "dfff9f7fbf75d025cf5b4f7b61ea9e24757f74a6934ba7249658e7e2de9d329f"
    version "3.0-milestone-1"
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
