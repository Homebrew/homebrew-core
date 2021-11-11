class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-7.3-all.zip"
  sha256 "00b273629df4ce46e68df232161d5a7c4e495b9a029ce6e0420f071e21316867"
  license "Apache-2.0"

  livecheck do
    url "https://services.gradle.org/distributions/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:[tz])/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c747e3263f9427eec63221e7e118080d3f927815d2759f52d2840edb8d086d21"
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
