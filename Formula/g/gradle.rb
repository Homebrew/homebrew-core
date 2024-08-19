class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.10-all.zip"
  sha256 "682b4df7fe5accdca84a4d1ef6a3a6ab096b3efd5edf7de2bd8c758d95a93703"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76efc1a8a88b3b7bcfa34e464deab59ab120ab630a950d4ebf9b202a535c4e01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76efc1a8a88b3b7bcfa34e464deab59ab120ab630a950d4ebf9b202a535c4e01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76efc1a8a88b3b7bcfa34e464deab59ab120ab630a950d4ebf9b202a535c4e01"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5b4d9a4e299179c513419ff0bd1658c9f47da9454a9b276f1b08fe77b2fd2aa"
    sha256 cellar: :any_skip_relocation, ventura:        "c5b4d9a4e299179c513419ff0bd1658c9f47da9454a9b276f1b08fe77b2fd2aa"
    sha256 cellar: :any_skip_relocation, monterey:       "c5b4d9a4e299179c513419ff0bd1658c9f47da9454a9b276f1b08fe77b2fd2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76efc1a8a88b3b7bcfa34e464deab59ab120ab630a950d4ebf9b202a535c4e01"
  end

  # https://github.com/gradle/gradle/blob/master/platforms/documentation/docs/src/docs/userguide/releases/compatibility.adoc
  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat"])
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
