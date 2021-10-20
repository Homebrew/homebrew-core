class GradleAT6 < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-6.9.1-all.zip"
  sha256 "b13f5d97f08000996bf12d9dd70af3f2c6b694c2c663ab1b545e9695562ad1ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fd167292281521adf832093bbc0485f5a03e82c9962039f54f12e59d0d2dce1b"
    sha256 cellar: :any_skip_relocation, all:          "32c1d054414d080476d5486e45826643e65cc6e2aaa463f1bb806cf6de89ad5c"
  end

  keg_only :versioned_formula

  # gradle@6 does not support Java 16
  depends_on "openjdk@11"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib src]
    (bin/"gradle").write_env_script libexec/"bin/gradle", Language::Java.overridable_java_home_env("11")
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
