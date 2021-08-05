class GradleProfiler < Formula
  desc "Profiling and benchmarking tool for Gradle builds"
  homepage "https://github.com/gradle/gradle-profiler/"
  url "https://repo.gradle.org/gradle/ext-releases-local/org/gradle/profiler/gradle-profiler/0.16.0/gradle-profiler-0.16.0.zip"
  sha256 "f376581ed7b788d9d3d640a2ddde88747ce2e8a0e297991a77b98e6b7a257fbb"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://repo.gradle.org/ui/api/v1/download?repoKey=ext-releases-local&path=org%252Fgradle%252Fprofiler%252Fgradle-profiler%252Fmaven-metadata.xml"
    regex(%r{<version>\s*v?(\d+(?:\.\d+)+)\s*</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "92d79f184d9dff7724d483c56d3ab6822fde8e7b30008fa90b9a3f8b57bc304f"
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
