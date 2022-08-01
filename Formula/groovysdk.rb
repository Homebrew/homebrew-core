class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.4.zip"
  sha256 "5f15ba97715c56cc45a5aee82762e21bd7f3d8e88feeb258651974a356aa6cf9"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b240d031d112faa41cb07d52d1d145ebdd3743bd6e9c9ea9addcfeed48d985d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b240d031d112faa41cb07d52d1d145ebdd3743bd6e9c9ea9addcfeed48d985d"
    sha256 cellar: :any_skip_relocation, monterey:       "5631bdfe37fc0c073132e8f490871461b1eb1d81f8b91ca9f52622f5e3f879cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5631bdfe37fc0c073132e8f490871461b1eb1d81f8b91ca9f52622f5e3f879cc"
    sha256 cellar: :any_skip_relocation, catalina:       "5631bdfe37fc0c073132e8f490871461b1eb1d81f8b91ca9f52622f5e3f879cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b240d031d112faa41cb07d52d1d145ebdd3743bd6e9c9ea9addcfeed48d985d"
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
