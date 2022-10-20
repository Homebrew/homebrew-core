class GradleAT6 < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-6.9.2-all.zip"
  sha256 "8bde5c859a3ddf5d127ac77465fc24fa8a831d3d8d49e8248548f2cb87485ef1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30827d4a933e2feb56ae803c0a6f1f65bb888a49085bc38812c9def932aa49de"
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
