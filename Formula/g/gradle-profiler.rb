class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https://github.com/gradle/gradle-profiler/"
  url "https://search.maven.org/remotecontent?filepath=org/gradle/profiler/gradle-profiler/0.22.0/gradle-profiler-0.22.0.zip"
  sha256 "a269f05861d2682c3b98d050330764200bc322024762295713fab167d133283c"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/gradle/profiler/gradle-profiler/maven-metadata.xml"
    regex(%r{<version>\s*v?(\d+(?:\.\d+)+)\s*</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "768c3986e2042d8f35fe954ea0951d91a5aa7c53cca1013361f91f78321c0aec"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin lib]
    env = Language::Java.overridable_java_home_env
    (bin/"gradle-profiler").write_env_script libexec/"bin/gradle-profiler", env
  end

  test do
    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write 'println "Hello"'
    output = shell_output("#{bin}/gradle-profiler --gradle-version 8.11 --profile chrome-trace")
    assert_includes output, "* Writing results to"
  end
end
