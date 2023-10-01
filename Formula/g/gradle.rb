class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-8.3-all.zip"
  sha256 "bb09982fdf52718e4c7b25023d10df6d35a5fff969860bdf5a5bd27a3ab27a9e"
  license "Apache-2.0"

  livecheck do
    url "https://gradle.org/install/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:zip|t)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a05fd6ee0167769945296ee3e66eb0d72394db5216df3a53d3d2f596dcbc4a80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a05fd6ee0167769945296ee3e66eb0d72394db5216df3a53d3d2f596dcbc4a80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a05fd6ee0167769945296ee3e66eb0d72394db5216df3a53d3d2f596dcbc4a80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a05fd6ee0167769945296ee3e66eb0d72394db5216df3a53d3d2f596dcbc4a80"
    sha256 cellar: :any_skip_relocation, sonoma:         "743d679a05ca1ee12372d1220dea581173ddb31939b03476df19359ab82d24ba"
    sha256 cellar: :any_skip_relocation, ventura:        "743d679a05ca1ee12372d1220dea581173ddb31939b03476df19359ab82d24ba"
    sha256 cellar: :any_skip_relocation, monterey:       "743d679a05ca1ee12372d1220dea581173ddb31939b03476df19359ab82d24ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "743d679a05ca1ee12372d1220dea581173ddb31939b03476df19359ab82d24ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a05fd6ee0167769945296ee3e66eb0d72394db5216df3a53d3d2f596dcbc4a80"
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
