class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.23.zip"
  sha256 "3ebc981ae4ed3b89cc920119ce4cbefb1936594e09f2ad55a47d238638701645"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1e0f74ad33dda9d9efaa30523055b7b9f2e1b71fa78aa53079bd35d36429c8f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e0f74ad33dda9d9efaa30523055b7b9f2e1b71fa78aa53079bd35d36429c8f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e0f74ad33dda9d9efaa30523055b7b9f2e1b71fa78aa53079bd35d36429c8f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e0f74ad33dda9d9efaa30523055b7b9f2e1b71fa78aa53079bd35d36429c8f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4f7ab0a26faa7ce5848994bc7eb72696bef1df31319949eb3e9331938c28d9c"
    sha256 cellar: :any_skip_relocation, ventura:        "c4f7ab0a26faa7ce5848994bc7eb72696bef1df31319949eb3e9331938c28d9c"
    sha256 cellar: :any_skip_relocation, monterey:       "c4f7ab0a26faa7ce5848994bc7eb72696bef1df31319949eb3e9331938c28d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e0f74ad33dda9d9efaa30523055b7b9f2e1b71fa78aa53079bd35d36429c8f5"
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
