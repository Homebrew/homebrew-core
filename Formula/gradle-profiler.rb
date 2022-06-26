class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https://github.com/gradle/gradle-profiler/"
  url "https://search.maven.org/remotecontent?filepath=org/gradle/profiler/gradle-profiler/0.18.0/gradle-profiler-0.18.0.zip"
  sha256 "242f891590353161713c195f01a677d938cc74bb6f56832d2c76a6ab4a5a9d79"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/gradle/profiler/gradle-profiler/maven-metadata.xml"
    regex(%r{<version>\s*v?(\d+(?:\.\d+)+)\s*</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3cb58c2fb6c470c012c4ea7c89466c5327ba4dbe2660be27aaf1f0f4c6ba133"
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
