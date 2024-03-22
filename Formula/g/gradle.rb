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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "460b0107603d8f3244fcd0ebf1f5907623ddf9fd230c5e728f295c61609c9b59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "460b0107603d8f3244fcd0ebf1f5907623ddf9fd230c5e728f295c61609c9b59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "460b0107603d8f3244fcd0ebf1f5907623ddf9fd230c5e728f295c61609c9b59"
    sha256 cellar: :any_skip_relocation, sonoma:         "34f7f03211986ae74c5504ea0b83e540cfb41770eebad3e1ce2a6d177dd8617c"
    sha256 cellar: :any_skip_relocation, ventura:        "34f7f03211986ae74c5504ea0b83e540cfb41770eebad3e1ce2a6d177dd8617c"
    sha256 cellar: :any_skip_relocation, monterey:       "34f7f03211986ae74c5504ea0b83e540cfb41770eebad3e1ce2a6d177dd8617c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "460b0107603d8f3244fcd0ebf1f5907623ddf9fd230c5e728f295c61609c9b59"
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
