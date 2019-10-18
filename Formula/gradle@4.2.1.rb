class GradleAT421 < Formula
  desc "Open-source build automation tool based on the Groovy DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-4.2.1-all.zip"
  sha256 "7897b59fb45148cd8a79f078e5e4cef3861a252dd1a1af729d0c6e8a0a8703a8"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib media samples src]
    (bin/"gradle").write_env_script libexec/"bin/gradle", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")
  end
end
