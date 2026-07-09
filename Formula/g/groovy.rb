class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-5.0.7.zip"
  sha256 "2a84d2b2387b4b38ec7c9395e67273df7818b246897dcccacfdde30292a4f339"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/"
    regex(/href=.*?apache-groovy-binary[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f19d943b190effa8bef15443b009b639564a91b55ee72eef5844857fc70c9cc9"
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
