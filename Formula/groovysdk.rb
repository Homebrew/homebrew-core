class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.11.zip"
  sha256 "c9a7c86646a2024ca24ad9a4f02bf9b5e551d9db406adc3e12babc120ef9cffc"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ae754d8d069865c5d817b82d36afe5939f624ca302f7e24ceced055b6b6e658"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ae754d8d069865c5d817b82d36afe5939f624ca302f7e24ceced055b6b6e658"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ae754d8d069865c5d817b82d36afe5939f624ca302f7e24ceced055b6b6e658"
    sha256 cellar: :any_skip_relocation, ventura:        "376603bd06c84c081400386d8db34d6ce8d7ea8a6e813937889b17d6fd5c2a5b"
    sha256 cellar: :any_skip_relocation, monterey:       "376603bd06c84c081400386d8db34d6ce8d7ea8a6e813937889b17d6fd5c2a5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "376603bd06c84c081400386d8db34d6ce8d7ea8a6e813937889b17d6fd5c2a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae754d8d069865c5d817b82d36afe5939f624ca302f7e24ceced055b6b6e658"
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
