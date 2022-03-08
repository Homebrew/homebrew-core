class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.1.zip"
  sha256 "c30e0cf34f7fa65b434a359bf3dca3123674b9cdfd6572d08b640223e89f5b2b"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "255516e1748ccbfe9acff12e278d95cf444ecd7d061f62518135181c74f4bd28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "255516e1748ccbfe9acff12e278d95cf444ecd7d061f62518135181c74f4bd28"
    sha256 cellar: :any_skip_relocation, monterey:       "50bfa94e9e9a4deaead84aa3f2be2df068cd495ff5b7c667ce0756f6be26aef7"
    sha256 cellar: :any_skip_relocation, big_sur:        "50bfa94e9e9a4deaead84aa3f2be2df068cd495ff5b7c667ce0756f6be26aef7"
    sha256 cellar: :any_skip_relocation, catalina:       "50bfa94e9e9a4deaead84aa3f2be2df068cd495ff5b7c667ce0756f6be26aef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "255516e1748ccbfe9acff12e278d95cf444ecd7d061f62518135181c74f4bd28"
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
