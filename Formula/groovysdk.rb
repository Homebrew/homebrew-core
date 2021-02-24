class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://dl.bintray.com/groovy/maven/apache-groovy-sdk-3.0.7.zip"
  sha256 "dd45ea5349cd6d037ba3296c9be0521da1d8422d76e0c817f928007c7387027e"
  license "Apache-2.0"

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
