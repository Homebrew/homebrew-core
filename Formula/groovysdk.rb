class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.2.zip"
  sha256 "7bf19b75fbcc9c02c9823eacdfe21f54145ae467a6466be28a525570c78a2db8"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e330c6a65212b7dcb331e8486067bf2eca131be269d54958364025cb507030f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e330c6a65212b7dcb331e8486067bf2eca131be269d54958364025cb507030f8"
    sha256 cellar: :any_skip_relocation, monterey:       "f3e1901152f6d6e56f049131a28ddb2883974236ac371dae59884b55712d5094"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3e1901152f6d6e56f049131a28ddb2883974236ac371dae59884b55712d5094"
    sha256 cellar: :any_skip_relocation, catalina:       "f3e1901152f6d6e56f049131a28ddb2883974236ac371dae59884b55712d5094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e330c6a65212b7dcb331e8486067bf2eca131be269d54958364025cb507030f8"
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
