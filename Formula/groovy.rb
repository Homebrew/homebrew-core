class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-3.0.9.zip"
  sha256 "eb34f4ee229b1a424adb87df5b999f66d1b1285694e5332d0800896744c2e421"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/"
    regex(/href=.*?apache-groovy-binary[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "edd57e1b12bd69b5b2717649168c95a7d14daef492bb6342d2ce26f54d5e0393"
    sha256 cellar: :any_skip_relocation, big_sur:       "edd57e1b12bd69b5b2717649168c95a7d14daef492bb6342d2ce26f54d5e0393"
    sha256 cellar: :any_skip_relocation, catalina:      "edd57e1b12bd69b5b2717649168c95a7d14daef492bb6342d2ce26f54d5e0393"
    sha256 cellar: :any_skip_relocation, mojave:        "edd57e1b12bd69b5b2717649168c95a7d14daef492bb6342d2ce26f54d5e0393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe39b4c967fad083cd7c6a5f74fdeb5e2104d0322760022e739d7e55f1020aa"
    sha256 cellar: :any_skip_relocation, all:           "72b30ad60e355ecfb5ae271ed8afcb317dd5387cbbc2110ce212ac4c7e210bc6"
  end

  depends_on "openjdk"

  conflicts_with "groovysdk", because: "both install the same binaries"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]

    libexec.install "bin", "conf", "lib"
    bin.install Dir["#{libexec}/bin/*"] - ["#{libexec}/bin/groovy.ico"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You should set GROOVY_HOME:
        export GROOVY_HOME=#{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
