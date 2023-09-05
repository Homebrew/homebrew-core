class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.14.zip"
  sha256 "80f889881b4bf20aaf212b9206c10334fd2c7f2a38d979a82baa883976116e2b"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f0515c0e2a40c687c9e4332d96c2c272ea8e7b9ac9a6e7bf0cbd64a8ca889eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f0515c0e2a40c687c9e4332d96c2c272ea8e7b9ac9a6e7bf0cbd64a8ca889eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f0515c0e2a40c687c9e4332d96c2c272ea8e7b9ac9a6e7bf0cbd64a8ca889eb"
    sha256 cellar: :any_skip_relocation, ventura:        "27f9656f097c079ff1f0fc40fe1494c31908a7743c6f4fbd9de62480a64e5504"
    sha256 cellar: :any_skip_relocation, monterey:       "27f9656f097c079ff1f0fc40fe1494c31908a7743c6f4fbd9de62480a64e5504"
    sha256 cellar: :any_skip_relocation, big_sur:        "27f9656f097c079ff1f0fc40fe1494c31908a7743c6f4fbd9de62480a64e5504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f0515c0e2a40c687c9e4332d96c2c272ea8e7b9ac9a6e7bf0cbd64a8ca889eb"
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
