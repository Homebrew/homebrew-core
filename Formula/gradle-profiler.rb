class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https://github.com/gradle/gradle-profiler/"
  url "https://repo.gradle.org/gradle/ext-releases-local/org/gradle/profiler/gradle-profiler/0.16.0/gradle-profiler-0.16.0.zip"
  sha256 "f376581ed7b788d9d3d640a2ddde88747ce2e8a0e297991a77b98e6b7a257fbb"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    env = Language::Java.overridable_java_home_env
    (bin/"gradle-profiler").write_env_script libexec/"bin/gradle-profiler", env
  end

  test do
    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write 'println "Hello"'
    output = shell_output("#{bin}/gradle-profiler --gradle-version 7.0 --profile chrome-trace")
    assert_includes output, "* Results written to"
  end
end
