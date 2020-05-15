class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-6.4.1-all.zip"
  sha256 "3fd824892df8ad5847be6e4fb7d3600068437de172939fd657cc280a1a629f63"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib src]
    (bin/"gradle").write_env_script libexec/"bin/gradle",
      :JAVA_HOME => "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")

    (testpath/"build.gradle").write <<~EOS
      println "gradle works!"
    EOS
    gradle_output = shell_output("#{bin}/gradle build --no-daemon")
    assert_includes gradle_output, "gradle works!"
  end
end
