class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.13.zip"
  sha256 "fe85b76daab5ef9c27f39f7245c9bfc5e4c29580cdccfc2f60e279857d9e2154"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f33168bab50e7584f5cd869c9c7a4409a4d79538a36d437c3e3a031e19068cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f33168bab50e7584f5cd869c9c7a4409a4d79538a36d437c3e3a031e19068cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f33168bab50e7584f5cd869c9c7a4409a4d79538a36d437c3e3a031e19068cd"
    sha256 cellar: :any_skip_relocation, ventura:        "28cddc1b0d45ce3bd0fdf7e34199d0c092833df95d1f1d3d3a2e8dce15a481fc"
    sha256 cellar: :any_skip_relocation, monterey:       "28cddc1b0d45ce3bd0fdf7e34199d0c092833df95d1f1d3d3a2e8dce15a481fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "28cddc1b0d45ce3bd0fdf7e34199d0c092833df95d1f1d3d3a2e8dce15a481fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f33168bab50e7584f5cd869c9c7a4409a4d79538a36d437c3e3a031e19068cd"
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
