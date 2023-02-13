class GradleAT7 < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-7.6-all.zip"
  sha256 "312eb12875e1747e05c2f81a4789902d7e4ec5defbd1eefeaccc08acf096505d"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ba00f5fb6200ba402ef737e47cd3c3c079d77466299c7ef49ed28de3b1c4dc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ba00f5fb6200ba402ef737e47cd3c3c079d77466299c7ef49ed28de3b1c4dc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ba00f5fb6200ba402ef737e47cd3c3c079d77466299c7ef49ed28de3b1c4dc5"
    sha256 cellar: :any_skip_relocation, ventura:        "4ba00f5fb6200ba402ef737e47cd3c3c079d77466299c7ef49ed28de3b1c4dc5"
    sha256 cellar: :any_skip_relocation, monterey:       "4ba00f5fb6200ba402ef737e47cd3c3c079d77466299c7ef49ed28de3b1c4dc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4be64b296fb7a3b5c16d7807dd278dbcb2fbc21a6209e65786e0548f48cffc44"
    sha256 cellar: :any_skip_relocation, catalina:       "4be64b296fb7a3b5c16d7807dd278dbcb2fbc21a6209e65786e0548f48cffc44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ba00f5fb6200ba402ef737e47cd3c3c079d77466299c7ef49ed28de3b1c4dc5"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib src]
    env = Language::Java.overridable_java_home_env("19")
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
