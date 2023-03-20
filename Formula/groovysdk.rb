class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.10.zip"
  sha256 "3f56ac263b9c8d5b43a006688ad9365782856550b116e75281065324a36bc41e"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b38887b6ad0651ecabf6f83dd1a2fa2030ea8aa717141f265dec5202d21f80d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b38887b6ad0651ecabf6f83dd1a2fa2030ea8aa717141f265dec5202d21f80d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b38887b6ad0651ecabf6f83dd1a2fa2030ea8aa717141f265dec5202d21f80d"
    sha256 cellar: :any_skip_relocation, ventura:        "4073271d286cd8be0905c55da9e40ca5a79ffc591e516e9a4615dc253d7542f2"
    sha256 cellar: :any_skip_relocation, monterey:       "4073271d286cd8be0905c55da9e40ca5a79ffc591e516e9a4615dc253d7542f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4073271d286cd8be0905c55da9e40ca5a79ffc591e516e9a4615dc253d7542f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b38887b6ad0651ecabf6f83dd1a2fa2030ea8aa717141f265dec5202d21f80d"
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
