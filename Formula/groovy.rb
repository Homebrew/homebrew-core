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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a662b91af3884d93c8bc7a9d318eb82c749ab76750100ba2ff2c4e1be87852f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "b6e30d0087bd573350b73cef007f45dcf7f0652dbfab3b976150c7b9f5ff53ad"
    sha256 cellar: :any_skip_relocation, catalina:      "b6e30d0087bd573350b73cef007f45dcf7f0652dbfab3b976150c7b9f5ff53ad"
    sha256 cellar: :any_skip_relocation, mojave:        "b6e30d0087bd573350b73cef007f45dcf7f0652dbfab3b976150c7b9f5ff53ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e1e8ad43c0d8ec852bfd44f2b35ee54c98cf80aa84afe6e828b699fa737b930"
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
