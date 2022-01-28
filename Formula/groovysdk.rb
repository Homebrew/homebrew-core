class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.0.zip"
  sha256 "3dd2782573a422a9a399ea4ab3ae4c9ee64d16bf3e1553aa4bc7b4c50a2b5186"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3103793592e4d8c6392f5bf218e91698ffd2ad53a99002963ca4b8dd3c03fa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3103793592e4d8c6392f5bf218e91698ffd2ad53a99002963ca4b8dd3c03fa7"
    sha256 cellar: :any_skip_relocation, monterey:       "a0d0761356557724fede393dc0168097b07340a626875936dfca34dacc5a9f71"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0d0761356557724fede393dc0168097b07340a626875936dfca34dacc5a9f71"
    sha256 cellar: :any_skip_relocation, catalina:       "a0d0761356557724fede393dc0168097b07340a626875936dfca34dacc5a9f71"
    sha256 cellar: :any_skip_relocation, mojave:         "a0d0761356557724fede393dc0168097b07340a626875936dfca34dacc5a9f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3103793592e4d8c6392f5bf218e91698ffd2ad53a99002963ca4b8dd3c03fa7"
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
