class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.3.zip"
  sha256 "7c2e0df8d4c2b4695cb127bcef31e40223671215866fcf23da6fdccbb5ff93c5"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65a328dcc3694f1b1277e051e6e1debb2457ae39745aedb766ed3cad06a3b854"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65a328dcc3694f1b1277e051e6e1debb2457ae39745aedb766ed3cad06a3b854"
    sha256 cellar: :any_skip_relocation, monterey:       "26e75d165fe4cac18b564b24ed32bf8ea9bb751e179ed3a088f386998ebc58a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "26e75d165fe4cac18b564b24ed32bf8ea9bb751e179ed3a088f386998ebc58a5"
    sha256 cellar: :any_skip_relocation, catalina:       "26e75d165fe4cac18b564b24ed32bf8ea9bb751e179ed3a088f386998ebc58a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65a328dcc3694f1b1277e051e6e1debb2457ae39745aedb766ed3cad06a3b854"
  end

  depends_on "openjdk"

  conflicts_with "groovy", because: "both install the same binaries"

  def install
    # We don't need Windows' files.
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    bin.install Dir["bin/*"]
    libexec.install "conf", "lib", "src", "doc"
    bin.env_script_all_files libexec/"bin",
                             GROOVY_HOME: libexec,
                             JAVA_HOME:   "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
