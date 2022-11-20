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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c24b69dd0fdb335baf3384a7c82743ac25e658d13f60ee55c3ee7d0773b3d137"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c24b69dd0fdb335baf3384a7c82743ac25e658d13f60ee55c3ee7d0773b3d137"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c24b69dd0fdb335baf3384a7c82743ac25e658d13f60ee55c3ee7d0773b3d137"
    sha256 cellar: :any_skip_relocation, ventura:        "91e99e4eb7c4dea647ca04f8c8e04f8a597e1c91d9b0ac201d3e1058cd460b0e"
    sha256 cellar: :any_skip_relocation, monterey:       "91e99e4eb7c4dea647ca04f8c8e04f8a597e1c91d9b0ac201d3e1058cd460b0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "91e99e4eb7c4dea647ca04f8c8e04f8a597e1c91d9b0ac201d3e1058cd460b0e"
    sha256 cellar: :any_skip_relocation, catalina:       "91e99e4eb7c4dea647ca04f8c8e04f8a597e1c91d9b0ac201d3e1058cd460b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c24b69dd0fdb335baf3384a7c82743ac25e658d13f60ee55c3ee7d0773b3d137"
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
