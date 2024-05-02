class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.7-all.zip"
  sha256 "194717442575a6f96e1c1befa2c30e9a4fc90f701d7aee33eb879b79e7ff05c0"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02120d61732a8fa55d3800dcd8e7ca737a0c0ad82c590d6e4bad6545cebd52aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02120d61732a8fa55d3800dcd8e7ca737a0c0ad82c590d6e4bad6545cebd52aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02120d61732a8fa55d3800dcd8e7ca737a0c0ad82c590d6e4bad6545cebd52aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "aeadc9c405ea2d083f5d8f481bb82cbd4f73c570dd0f08bbf37606364e11b512"
    sha256 cellar: :any_skip_relocation, ventura:        "aeadc9c405ea2d083f5d8f481bb82cbd4f73c570dd0f08bbf37606364e11b512"
    sha256 cellar: :any_skip_relocation, monterey:       "aeadc9c405ea2d083f5d8f481bb82cbd4f73c570dd0f08bbf37606364e11b512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02120d61732a8fa55d3800dcd8e7ca737a0c0ad82c590d6e4bad6545cebd52aa"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env
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
