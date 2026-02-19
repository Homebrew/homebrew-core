class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-5.0.4.zip"
  sha256 "5e5e9a468d4344e0c8ee0cd68c62751ccf4e5f8f84d7ad9b8abc6a01014b9f79"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/"
    regex(/href=.*?apache-groovy-binary[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "025c2288286fb516196d369e53b1ec2a8e4072ad0f562738ddf12ffb5cde32cf"
  end

  depends_on "openjdk"

  conflicts_with "groovysdk", because: "both install the same binaries"

  def install
    libexec.install "conf", "lib"

    buildpath.glob("bin/*").each do |f|
      next if f.extname == ".bat"
      next if f.extname == ".ico"
      next if f.basename.to_s.end_with?("_completion")

      bin.install f
    end

    env = Language::Java.overridable_java_home_env
    env["GROOVY_HOME"] = "${GROOVY_HOME:-#{libexec}}"
    bin.env_script_all_files libexec/"bin", env

    buildpath.glob("bin/*.ico").each { |f| (libexec/"bin").install f }
    buildpath.glob("bin/*_completion").each { |f| bash_completion.install f => File.basename(f, "_completion") }
  end

  test do
    output = shell_output("#{bin}/grape install org.activiti activiti-engine 5.16.4")
    assert_match "found org.activiti#activiti-engine;5.16.4", output
    assert_match "65536", pipe_output("#{bin}/groovysh", "println 64*1024\n:exit\n")
  end
end
