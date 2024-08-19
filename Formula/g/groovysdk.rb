class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.22.zip"
  sha256 "17448950dea0280f708c778c43d0d1b41778ba58c5b4128a8ba1e7c0bed75bea"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8296da40a4c7a69cb3eb75459a1d42c1c9b8eb25cfe3de38f14ed0758751725b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8296da40a4c7a69cb3eb75459a1d42c1c9b8eb25cfe3de38f14ed0758751725b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8296da40a4c7a69cb3eb75459a1d42c1c9b8eb25cfe3de38f14ed0758751725b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4f6bb8b176ef61ed4012b675e7cf2895e144839a3dfd99214d56200d4c84a37"
    sha256 cellar: :any_skip_relocation, ventura:        "e4f6bb8b176ef61ed4012b675e7cf2895e144839a3dfd99214d56200d4c84a37"
    sha256 cellar: :any_skip_relocation, monterey:       "e4f6bb8b176ef61ed4012b675e7cf2895e144839a3dfd99214d56200d4c84a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0661560d09bc7d775e653c302ffc2a5b0367e706d0250faf8972b795efa41eed"
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
