class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-sdk-4.0.21.zip"
  sha256 "983dd01aae4380a3d9fb28a691755418a39b4763d71cbe8447c9d253cb5f1134"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.apache.org/download.html"
    regex(/href=.*?apache-groovy-sdk[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd987cc9cac8b93ac9d72f6e07cded1e6ec901a9bebd6398f91e9f21939d6777"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd987cc9cac8b93ac9d72f6e07cded1e6ec901a9bebd6398f91e9f21939d6777"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd987cc9cac8b93ac9d72f6e07cded1e6ec901a9bebd6398f91e9f21939d6777"
    sha256 cellar: :any_skip_relocation, sonoma:         "afccdf36e666147a6387bc9850367e006856c1b6490fbe8dd91347cba1750f4b"
    sha256 cellar: :any_skip_relocation, ventura:        "afccdf36e666147a6387bc9850367e006856c1b6490fbe8dd91347cba1750f4b"
    sha256 cellar: :any_skip_relocation, monterey:       "afccdf36e666147a6387bc9850367e006856c1b6490fbe8dd91347cba1750f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd987cc9cac8b93ac9d72f6e07cded1e6ec901a9bebd6398f91e9f21939d6777"
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
