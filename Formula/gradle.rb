class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-7.2-all.zip"
  sha256 "a8da5b02437a60819cad23e10fc7e9cf32bcb57029d9cb277e26eeff76ce014b"
  license "Apache-2.0"

  livecheck do
    url "https://services.gradle.org/distributions/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:[tz])/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "303a0a5cc54ee43b085f1b8a7cb2753ca2b21305b05628b3bf03383d71080cc2"
    sha256 cellar: :any_skip_relocation, big_sur:       "271f05a8828d3e763fc615ce1d709d1e01d5957f7a001f0723303ffe130a8251"
    sha256 cellar: :any_skip_relocation, catalina:      "271f05a8828d3e763fc615ce1d709d1e01d5957f7a001f0723303ffe130a8251"
    sha256 cellar: :any_skip_relocation, mojave:        "271f05a8828d3e763fc615ce1d709d1e01d5957f7a001f0723303ffe130a8251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15d4fa8e444f0127ea833fcb53099b3a92e13a0a39e7bffc5dd824a029f60736"
  end

  # gradle currently does not support Java 17
  if Hardware::CPU.arm?
    depends_on "openjdk@11"
  else
    depends_on "openjdk"
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib src]
    env = if Hardware::CPU.arm?
      Language::Java.overridable_java_home_env("11")
    else
      Language::Java.overridable_java_home_env
    end
    (bin/"gradle").write_env_script libexec/"bin/gradle", env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")

    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write <<~EOS
      println "gradle works!"
    EOS
    gradle_output = shell_output("#{bin}/gradle build --no-daemon")
    assert_includes gradle_output, "gradle works!"
  end
end
