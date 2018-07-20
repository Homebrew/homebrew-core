class GradleAT35 < Formula
  desc "Gradle build automation tool"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-3.5-all.zip"
  sha256 "d84bf6b6113da081d0082bcb63bd8547824c6967fe68704d1e3a6fde822b7212"
  bottle :unneeded
  option "with-all", "Installs Javadoc, examples, and source in addition to the binaries"
  depends_on :java => "1.7+"
  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    libexec.install %w[docs media samples src] if build.with? "all"
    (bin/"gradle").write_env_script libexec/"bin/gradle", Language::Java.java_home_env("1.7+")
  end
  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")
  end
end
