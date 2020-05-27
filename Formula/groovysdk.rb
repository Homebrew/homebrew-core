class Groovysdk < Formula
  desc "SDK for Groovy: a Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://dl.bintray.com/groovy/maven/apache-groovy-sdk-3.0.4.zip"
  sha256 "3b7c2b05bd01017096d027ac17abacc8dcd855a89582ec53a62f56de899fd230"

  bottle :unneeded

  depends_on "openjdk"

  conflicts_with "groovy", :because => "both install the same binaries"

  def install
    # We don't need Windows' files.
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    bin.install Dir["bin/*"]
    libexec.install "conf", "lib", "src", "doc"
    bin.env_script_all_files libexec/"bin",
                             :GROOVY_HOME => libexec,
                             :JAVA_HOME   => "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
