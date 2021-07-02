class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-7.1.1-all.zip"
  sha256 "9bb8bc05f562f2d42bdf1ba8db62f6b6fa1c3bf6c392228802cc7cb0578fe7e0"
  license "Apache-2.0"

  livecheck do
    url "https://services.gradle.org/distributions/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:[tz])/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4779bf19ae46197fa7d6e2f4f5dbbbc54ef9f4af886f7ccc4653c00532e15e9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad28a8e146697383f34ffc5fe61506d02c6706aef34092339f7e4f36ebab4af7"
    sha256 cellar: :any_skip_relocation, catalina:      "ad28a8e146697383f34ffc5fe61506d02c6706aef34092339f7e4f36ebab4af7"
    sha256 cellar: :any_skip_relocation, mojave:        "ad28a8e146697383f34ffc5fe61506d02c6706aef34092339f7e4f36ebab4af7"
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
