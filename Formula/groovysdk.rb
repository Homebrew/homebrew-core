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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b73879e96c22dfbac13154f1f5e557a22386b8780285e5c67ad27198fee1f4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b73879e96c22dfbac13154f1f5e557a22386b8780285e5c67ad27198fee1f4c"
    sha256 cellar: :any_skip_relocation, monterey:       "09dc5f5ee1f1888a936300bcb439b70e4782588fbe7669fed86fff15642afc76"
    sha256 cellar: :any_skip_relocation, big_sur:        "09dc5f5ee1f1888a936300bcb439b70e4782588fbe7669fed86fff15642afc76"
    sha256 cellar: :any_skip_relocation, catalina:       "09dc5f5ee1f1888a936300bcb439b70e4782588fbe7669fed86fff15642afc76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b73879e96c22dfbac13154f1f5e557a22386b8780285e5c67ad27198fee1f4c"
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
