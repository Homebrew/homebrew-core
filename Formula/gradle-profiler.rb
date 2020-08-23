class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https://github.com/gradle/gradle-profiler/"
  url "https://repo.gradle.org/gradle/ext-releases-local/org/gradle/profiler/gradle-profiler/0.12.0/gradle-profiler-0.12.0.zip"
  sha256 "0c8f6a8e9f62860e5ea675534057306d0e4a9b9607353338bab978b4fa0c8a17"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    (bin/"gradle-profiler").write_env_script libexec/"bin/gradle-profiler",
      JAVA_HOME: "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write 'println "Hello"'
    output = shell_output("#{bin}/gradle-profiler --gradle-version 6.5 --profile chrome-trace")
    assert_includes output, "* Results written to"
  end
end
