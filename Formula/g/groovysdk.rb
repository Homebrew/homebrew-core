class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.18.zip"
  sha256 "dbf8750c418de2e7aecec0cc84ffa24f72967578e16ddc7ccc559fb65239259c"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e90745b80d6fc8eb4befac0ba90732f81138662ee9d556d3fc977648dc695c75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e90745b80d6fc8eb4befac0ba90732f81138662ee9d556d3fc977648dc695c75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e90745b80d6fc8eb4befac0ba90732f81138662ee9d556d3fc977648dc695c75"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d4b7408b39948ca037dea6003a89ef6a0ed0244fecd67dba9cfd0455db6f8b7"
    sha256 cellar: :any_skip_relocation, ventura:        "9d4b7408b39948ca037dea6003a89ef6a0ed0244fecd67dba9cfd0455db6f8b7"
    sha256 cellar: :any_skip_relocation, monterey:       "9d4b7408b39948ca037dea6003a89ef6a0ed0244fecd67dba9cfd0455db6f8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e90745b80d6fc8eb4befac0ba90732f81138662ee9d556d3fc977648dc695c75"
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
