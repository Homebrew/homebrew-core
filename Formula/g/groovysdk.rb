class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.24.zip"
  sha256 "61f360d1c1b1316082bca4af9ef88954ec55ac1ec4b49a3e0c9cb9b723172a8a"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98589d880eb28fd123bc6767b26155b92f5e010e6aa5da18046b3d886b4fcf98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98589d880eb28fd123bc6767b26155b92f5e010e6aa5da18046b3d886b4fcf98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98589d880eb28fd123bc6767b26155b92f5e010e6aa5da18046b3d886b4fcf98"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c1602220d7f6a31c2ffe8584ded688fcfb98e402b69bf705a6091c1e0fd5309"
    sha256 cellar: :any_skip_relocation, ventura:       "8c1602220d7f6a31c2ffe8584ded688fcfb98e402b69bf705a6091c1e0fd5309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98589d880eb28fd123bc6767b26155b92f5e010e6aa5da18046b3d886b4fcf98"
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
