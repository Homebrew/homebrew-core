class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.15.zip"
  sha256 "f1c30a8ff9a14692b05156e22ab75f6ae86212e4ebe955df074d0026d49b6307"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1c329befe63cc9a690e8d3745098c73ecc308477c901e8c77f4e1daa6723808"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1c329befe63cc9a690e8d3745098c73ecc308477c901e8c77f4e1daa6723808"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1c329befe63cc9a690e8d3745098c73ecc308477c901e8c77f4e1daa6723808"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1c329befe63cc9a690e8d3745098c73ecc308477c901e8c77f4e1daa6723808"
    sha256 cellar: :any_skip_relocation, sonoma:         "f06ba3dc8e4bdcf9d5a50ab5fff171d523c40345e2f32fcbd06a7cec6ddf38b6"
    sha256 cellar: :any_skip_relocation, ventura:        "f06ba3dc8e4bdcf9d5a50ab5fff171d523c40345e2f32fcbd06a7cec6ddf38b6"
    sha256 cellar: :any_skip_relocation, monterey:       "f06ba3dc8e4bdcf9d5a50ab5fff171d523c40345e2f32fcbd06a7cec6ddf38b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f06ba3dc8e4bdcf9d5a50ab5fff171d523c40345e2f32fcbd06a7cec6ddf38b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1c329befe63cc9a690e8d3745098c73ecc308477c901e8c77f4e1daa6723808"
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
