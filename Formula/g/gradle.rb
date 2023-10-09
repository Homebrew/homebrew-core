class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.4-all.zip"
  sha256 "f2b9ed0faf8472cbe469255ae6c86eddb77076c75191741b4a462f33128dd419"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37fd452bf27f2996b459d9d24b1631a26e0625b4960f4219d0ff1db61e27faa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37fd452bf27f2996b459d9d24b1631a26e0625b4960f4219d0ff1db61e27faa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37fd452bf27f2996b459d9d24b1631a26e0625b4960f4219d0ff1db61e27faa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e13e584cd2c8432c9c66f19d4a78b86cc75dceab0895f831ffc39e10806bd323"
    sha256 cellar: :any_skip_relocation, ventura:        "e13e584cd2c8432c9c66f19d4a78b86cc75dceab0895f831ffc39e10806bd323"
    sha256 cellar: :any_skip_relocation, monterey:       "e13e584cd2c8432c9c66f19d4a78b86cc75dceab0895f831ffc39e10806bd323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37fd452bf27f2996b459d9d24b1631a26e0625b4960f4219d0ff1db61e27faa4"
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
