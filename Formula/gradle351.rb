class Gradle351 < Formula
  desc "Gradle build automation tool"
  homepage "https://www.gradle.org/"
  url "https://downloads.gradle.org/distributions/gradle-3.5.1-bin.zip"
  sha256 "8dce35f52d4c7b4a4946df73aa2830e76ba7148850753d8b5e94c5dc325ceef8"

  bottle :unneeded
  depends_on :java => "1.7+"

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+"bin/gradle"
  end

  test do
    ENV["GRADLE_USER_HOME"] = testpath
    assert_match "Gradle #{version}", shell_output("#{bin}/gradle --version")
  end
end
