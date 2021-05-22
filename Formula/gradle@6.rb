class GradleAT6 < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-6.9-all.zip"
  sha256 "5d234488d2cac2ed556dc3c47096e189ad76a63cf304ebf124f756498922cf16"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54e094483acd546ddd781b44442fd190e4cf68b4c9845a51dc6a76dd3a568d50"
    sha256 cellar: :any_skip_relocation, big_sur:       "4da8b0ef695f99b6749c3fade78621827a5e77c887ee51349e9117c7b2a747ec"
    sha256 cellar: :any_skip_relocation, catalina:      "4da8b0ef695f99b6749c3fade78621827a5e77c887ee51349e9117c7b2a747ec"
    sha256 cellar: :any_skip_relocation, mojave:        "4da8b0ef695f99b6749c3fade78621827a5e77c887ee51349e9117c7b2a747ec"
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
