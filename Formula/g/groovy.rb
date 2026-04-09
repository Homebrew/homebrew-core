class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-5.0.5.zip"
  sha256 "eec490f4710cbb0811b935f78b4ec3da6d5eb19a25c692b3c7284ef9a1fc5182"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/"
    regex(/href=.*?apache-groovy-binary[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "14eef8360c8d36b0ce1a5d891ede6dd2b3a3569d3f96f725dfd4e210e17288f8"
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
