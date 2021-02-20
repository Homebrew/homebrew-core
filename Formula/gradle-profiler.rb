class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https://github.com/gradle/gradle-profiler/"
  url "https://repo.gradle.org/gradle/ext-releases-local/org/gradle/profiler/gradle-profiler/0.15.0/gradle-profiler-0.15.0.zip"
  sha256 "0cd279754502f796ea4bc684decd201cd8eea67566b3a6ef8b55f84cc4021d34"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    (bin/"gradle-profiler").write_env_script libexec/"bin/gradle-profiler", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write 'println "Hello"'
    output = shell_output("#{bin}/gradle-profiler --gradle-version 6.5 --profile chrome-trace")
    assert_includes output, "* Results written to"
  end
end
