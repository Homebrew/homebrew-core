class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.6.zip"
  sha256 "2cadb807f539076ab98c4737a2e7c7a0e993dd82f3eb63ddb7b5a49b6d4790ca"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79b9c998f5c3f0a961ab63491726952a236e805c9da173566e69487dea119080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79b9c998f5c3f0a961ab63491726952a236e805c9da173566e69487dea119080"
    sha256 cellar: :any_skip_relocation, monterey:       "64cf99e62085ae285e63b01e4b48ac3d168ab0d67b0244132e9770f4af870c9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "64cf99e62085ae285e63b01e4b48ac3d168ab0d67b0244132e9770f4af870c9f"
    sha256 cellar: :any_skip_relocation, catalina:       "64cf99e62085ae285e63b01e4b48ac3d168ab0d67b0244132e9770f4af870c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79b9c998f5c3f0a961ab63491726952a236e805c9da173566e69487dea119080"
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
