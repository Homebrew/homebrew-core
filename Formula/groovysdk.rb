class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://dl.bintray.com/groovy/maven/apache-groovy-sdk-3.0.5.zip"
  sha256 "22537785771c58f31ab7e32e7fdb4b96b8d15f1bb7bff4b0e211b0d904d3f623"

  livecheck do
    url "https://dl.bintray.com/groovy/maven/"
    regex(/href=.*?apache-groovy-sdk[._-]v?([\d.]+)\.zip/i)
  end

  bottle :unneeded

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
