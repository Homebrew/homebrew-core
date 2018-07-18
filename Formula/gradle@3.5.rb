class GradleAT35 < Formula
  desc "Gradle build automation tool"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-3.5-bin.zip"
  sha256 "0b7450798c190ff76b9f9a3d02e18b33d94553f708ebc08ebe09bdf99111d110"

  bottle :unneeded
  
  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+"bin/gradle"
  end

  test do
    ENV["GRADLE_USER_HOME"] = testpath
    assert_match "Gradle #{version}", shell_output("#{bin}/gradle --version")
  end
end
