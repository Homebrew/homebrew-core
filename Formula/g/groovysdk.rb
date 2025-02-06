class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.25.zip"
  sha256 "747004e9de503a615034d5f57e63a0608d11c3d6d8a4f20ea3760e64d1a471da"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3b512377361d281b6c275f3113d986607070bb5e24d76be54a936241cd31708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3b512377361d281b6c275f3113d986607070bb5e24d76be54a936241cd31708"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3b512377361d281b6c275f3113d986607070bb5e24d76be54a936241cd31708"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e19ad027f51679a6d23ec7d211811505f216fa75cc0740d0e43021156647313"
    sha256 cellar: :any_skip_relocation, ventura:       "5e19ad027f51679a6d23ec7d211811505f216fa75cc0740d0e43021156647313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b512377361d281b6c275f3113d986607070bb5e24d76be54a936241cd31708"
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
                             JAVA_HOME:   "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    system bin/"grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
