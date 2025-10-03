class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https://github.com/gradle/gradle-profiler/"
  # TODO: Check if we can use `openjdk` 25+ when bumping the version.
  url "https://search.maven.org/remotecontent?filepath=org/gradle/profiler/gradle-profiler/0.22.0/gradle-profiler-0.22.0.zip"
  sha256 "a269f05861d2682c3b98d050330764200bc322024762295713fab167d133283c"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/gradle/profiler/gradle-profiler/maven-metadata.xml"
    regex(%r{<version>\s*v?(\d+(?:\.\d+)+)\s*</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c64c32aa7596b3325c76e5488d5887b16ce2721d7dc59562e9f198886e8f019"
  end

  depends_on "openjdk@21"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin lib]
    env = Language::Java.overridable_java_home_env("21")
    (bin/"gradle-profiler").write_env_script libexec/"bin/gradle-profiler", env
  end

  test do
    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write 'println "Hello"'
    output = shell_output("#{bin}/gradle-profiler --gradle-version 8.14 --profile chrome-trace")
    assert_includes output, "* Writing results to"
  end
end
