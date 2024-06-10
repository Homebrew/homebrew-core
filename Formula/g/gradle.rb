class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.8-all.zip"
  sha256 "f8b4f4772d302c8ff580bc40d0f56e715de69b163546944f787c87abf209c961"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efcdc5e35e4c84992247cca63dc6e4cfa9fb560e3887c2e4caafa62d7cad045c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efcdc5e35e4c84992247cca63dc6e4cfa9fb560e3887c2e4caafa62d7cad045c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efcdc5e35e4c84992247cca63dc6e4cfa9fb560e3887c2e4caafa62d7cad045c"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd2537fef2d3504b1b195131abbfbf302a4d4bf2e86984249dd4e8dcc2c2d1a5"
    sha256 cellar: :any_skip_relocation, ventura:        "bd2537fef2d3504b1b195131abbfbf302a4d4bf2e86984249dd4e8dcc2c2d1a5"
    sha256 cellar: :any_skip_relocation, monterey:       "bd2537fef2d3504b1b195131abbfbf302a4d4bf2e86984249dd4e8dcc2c2d1a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "834067560a7903b2bbd9c686b4830e736157ddbcedeb655a19fb565e735c42de"
  end

  # no java 22 support for gradle 8.7
  # https://github.com/gradle/gradle/blob/master/platforms/documentation/docs/src/docs/userguide/releases/compatibility.adoc
  depends_on "openjdk@21"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env("21")
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
