class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https://github.com/gradle/gradle-profiler/"
  url "https://search.maven.org/remotecontent?filepath=org/gradle/profiler/gradle-profiler/0.21.0/gradle-profiler-0.21.0.zip"
  sha256 "0631e3fdcaa64eef345a55c32a2dbd4cb252b791b1e9457dd7b98790f7e8d0b6"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/gradle/profiler/gradle-profiler/maven-metadata.xml"
    regex(%r{<version>\s*v?(\d+(?:\.\d+)+)\s*</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "efaeffff25c03add41a89b4b1b7fcde8be147afd96baae57366787ffa9ba5c90"
  end

  # gradle currently does not support Java 17 (ARM)
  # gradle@6 is still default gradle-version, but does not support Java 16
  # Switch to `openjdk` once above situations are no longer true
  depends_on "openjdk@11"

  def install
    rm(Dir["bin/*.bat"])
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
