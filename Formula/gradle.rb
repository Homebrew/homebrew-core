class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-7.0.2-all.zip"
  sha256 "13bf8d3cf8eeeb5770d19741a59bde9bd966dd78d17f1bbad787a05ef19d1c2d"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://services.gradle.org/distributions/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:[tz])/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b3b39dd6943031660b05d88972179aaf57d18227077c49b3590a5174501240f"
    sha256 cellar: :any_skip_relocation, big_sur:       "e6fe8586f00011efce1876ac2e6a9f48a5bef1cd7f09d7c575eb83432ec678b2"
    sha256 cellar: :any_skip_relocation, catalina:      "e6fe8586f00011efce1876ac2e6a9f48a5bef1cd7f09d7c575eb83432ec678b2"
    sha256 cellar: :any_skip_relocation, mojave:        "e6fe8586f00011efce1876ac2e6a9f48a5bef1cd7f09d7c575eb83432ec678b2"
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
