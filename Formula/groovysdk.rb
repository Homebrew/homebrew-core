class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.12.zip"
  sha256 "d5dbc60d65b76d857a53d6e48a5cd01ceb6df570be934fdc312e8867f509a31c"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56c9e080bec8f165ac9b2de136672c62b38880c83f7ddd047adfab899884ecf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56c9e080bec8f165ac9b2de136672c62b38880c83f7ddd047adfab899884ecf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56c9e080bec8f165ac9b2de136672c62b38880c83f7ddd047adfab899884ecf6"
    sha256 cellar: :any_skip_relocation, ventura:        "0bd1c70216a0c841e41a5b5de5de67ec121d749d11c4b645dd01339868cc6289"
    sha256 cellar: :any_skip_relocation, monterey:       "0bd1c70216a0c841e41a5b5de5de67ec121d749d11c4b645dd01339868cc6289"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bd1c70216a0c841e41a5b5de5de67ec121d749d11c4b645dd01339868cc6289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56c9e080bec8f165ac9b2de136672c62b38880c83f7ddd047adfab899884ecf6"
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
