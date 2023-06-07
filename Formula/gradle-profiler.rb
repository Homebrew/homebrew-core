class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https://github.com/gradle/gradle-profiler/"
  url "https://search.maven.org/remotecontent?filepath=org/gradle/profiler/gradle-profiler/0.19.0/gradle-profiler-0.19.0.zip"
  sha256 "abc1f506a023752d5b4a23c5661baef3761ce802f5bb6904c486b3158bd893ac"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/gradle/profiler/gradle-profiler/maven-metadata.xml"
    regex(%r{<version>\s*v?(\d+(?:\.\d+)+)\s*</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35eca25614876310b3769a9c36507ff4e43297c1089dc15360b312e9d107f9e8"
  end

  # gradle currently does not support Java 17 (ARM)
  # gradle@6 is still default gradle-version, but does not support Java 16
  # Switch to `openjdk` once above situations are no longer true
  depends_on "openjdk@11"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    env = Language::Java.overridable_java_home_env("11")
    (bin/"gradle-profiler").write_env_script libexec/"bin/gradle-profiler", env
  end

  test do
    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write 'println "Hello"'
    output = shell_output("#{bin}/gradle-profiler --gradle-version 7.0 --profile chrome-trace")
    assert_includes output, "* Results written to"
  end
end
