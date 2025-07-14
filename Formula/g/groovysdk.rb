class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.27.zip"
  sha256 "edcb6f4e4a84416a5b19ad3c3ba1d569dd4948666a152796a8927dbb21d841f5"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a41df9c2f09b0a28f62fde68efa1ce74c8e8fb28e19fef839a8223fdac923cf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a41df9c2f09b0a28f62fde68efa1ce74c8e8fb28e19fef839a8223fdac923cf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a41df9c2f09b0a28f62fde68efa1ce74c8e8fb28e19fef839a8223fdac923cf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "de59ba8e4ac8f566741a882acaf11e6eb329c3febe111c564ffbeecf0d6532e6"
    sha256 cellar: :any_skip_relocation, ventura:       "de59ba8e4ac8f566741a882acaf11e6eb329c3febe111c564ffbeecf0d6532e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a41df9c2f09b0a28f62fde68efa1ce74c8e8fb28e19fef839a8223fdac923cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a41df9c2f09b0a28f62fde68efa1ce74c8e8fb28e19fef839a8223fdac923cf4"
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
