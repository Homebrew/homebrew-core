class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-3.0.9.zip"
  sha256 "8bce7b90612bcfe8d19adce26335b25a9955aeaaa8a9e89df8b8769a77e97187"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22daf0bb0900a5f6201cf692d481d289bb14b8f82ea7bb6e8d584d0345b72b7a"
    sha256 cellar: :any_skip_relocation, big_sur:       "3131d94d95871be2f1656f184b41e1629a5597335cd1403aee3023e9331d9dfd"
    sha256 cellar: :any_skip_relocation, catalina:      "3131d94d95871be2f1656f184b41e1629a5597335cd1403aee3023e9331d9dfd"
    sha256 cellar: :any_skip_relocation, mojave:        "3131d94d95871be2f1656f184b41e1629a5597335cd1403aee3023e9331d9dfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6be3efaa4fee0cc1a283f08039679270c8e500f54fde12b56fd453fd803e48e"
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
