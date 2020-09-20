class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https://github.com/gradle/gradle-profiler/"
  url "https://repo.gradle.org/gradle/ext-releases-local/org/gradle/profiler/gradle-profiler/0.14.0/gradle-profiler-0.14.0.zip"
  sha256 "0a47504895eecff7cb89fd79efeff3c406f4ccb3d0af49a6749eecb1178e1c1a"
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
