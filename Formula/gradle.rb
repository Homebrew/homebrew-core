class Gradle < Formula
  desc "Build system based on the Groovy language"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-4.0.2-all.zip"
  sha256 "b683cb9f8510f3ae9533871e6b244c24eb9398e8c5b432471f91f48dbc91e7a9"

  devel do
    url "https://services.gradle.org/distributions/gradle-4.1-rc-1-all.zip"
    version "4.1-rc-1"
    sha256 "eb504c25abae8ee43e01a56f6873137d74ce68c43b8b1fe89dc0562e6b81ca51"
  end

  bottle :unneeded

  option "with-all", "Installs Javadoc, examples, and source in addition to the binaries"

  depends_on :java => "1.7+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    libexec.install %w[docs media samples src] if build.with? "all"
    (bin/"gradle").write_env_script libexec/"bin/gradle", Language::Java.overridable_java_home_env
  end

  test do
    ENV.java_cache
    assert_match version.to_s, shell_output("#{bin}/gradle --version")
  end
end
