class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.26.zip"
  sha256 "8fb9e2e14621ea93b1f4d56859a034bca2f28b0dad36a9f528fa23a3603fba6f"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a9c17b629d23fde4101a454445cab31c9e49a4c02e94df28b8d692094552a09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a9c17b629d23fde4101a454445cab31c9e49a4c02e94df28b8d692094552a09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a9c17b629d23fde4101a454445cab31c9e49a4c02e94df28b8d692094552a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab654d4dc0713f847e624ba123156703e4fb60a85e1da7312e7a65186a71aa1b"
    sha256 cellar: :any_skip_relocation, ventura:       "ab654d4dc0713f847e624ba123156703e4fb60a85e1da7312e7a65186a71aa1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a9c17b629d23fde4101a454445cab31c9e49a4c02e94df28b8d692094552a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a9c17b629d23fde4101a454445cab31c9e49a4c02e94df28b8d692094552a09"
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
