class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-5.0.7.zip"
  sha256 "81b840deaca0009f5af73f70374138fc948bb175271a66168cbbf49963a8ab7c"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f26cfbffa0e19784817862e258cbfe948384166b5a917b76a0fd76d5519905ad"
  end

  depends_on "openjdk"

  conflicts_with "groovy", because: "both install the same binaries"

  def install
    # We don't need Windows' files.
    rm(Dir["bin/*.bat"])

    bin.install Dir["bin/*"]
    libexec.install "conf", "lib", "src", "doc"
    bin.env_script_all_files libexec/"bin",
                             GROOVY_HOME: libexec,
                             JAVA_HOME:   "${JAVA_HOME:-#{formula_opt_prefix("openjdk")}}"
  end

  test do
    system bin/"grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
