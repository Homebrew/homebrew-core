class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.17.zip"
  sha256 "d5ae8d088b038c82941bbce822c0ad00b577df069a5b82bde8a9be94683a71da"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1d4ad5b71681386a1dd553f8ef70b24fb577b9146e6b48ddca3d3b55852e8bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1d4ad5b71681386a1dd553f8ef70b24fb577b9146e6b48ddca3d3b55852e8bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1d4ad5b71681386a1dd553f8ef70b24fb577b9146e6b48ddca3d3b55852e8bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "72de5dce1b8d6a622274d7b0682322ed267770dd0f8873a5e4e874fbad6bd174"
    sha256 cellar: :any_skip_relocation, ventura:        "72de5dce1b8d6a622274d7b0682322ed267770dd0f8873a5e4e874fbad6bd174"
    sha256 cellar: :any_skip_relocation, monterey:       "72de5dce1b8d6a622274d7b0682322ed267770dd0f8873a5e4e874fbad6bd174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1d4ad5b71681386a1dd553f8ef70b24fb577b9146e6b48ddca3d3b55852e8bc"
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
