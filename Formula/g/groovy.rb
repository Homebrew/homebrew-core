class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-5.0.6.zip"
  sha256 "14300bca33dc6a911ed5e2c6bc5b83b63fa8a5278e791820ff7e70fc76d06e1d"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/"
    regex(/href=.*?apache-groovy-binary[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7724b5b5bb03cfaba2b700a5af69abf0dddfa2c66bace18353121c614a2ba860"
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
